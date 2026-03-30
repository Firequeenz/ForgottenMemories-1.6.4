extends Node2D

@onready var background = $Background
@onready var text_label = $TextLabel
@onready var char_box = $Char
@onready var buttons = $Buttons
@onready var fade_rect = $FadeRect
@onready var sfx_player = $SFXPlayer
@onready var bgm_player = $BGMPlayer


var char_box_original_pos: Vector2 = Vector2.ZERO


var current_step: int = 0
var is_animating: bool = false
var buttons_visible: bool = false
var current_enemy: String = "Simon Muran"
var last_click_time: int = 0
var input_locked: bool = false


var audio_player: AudioStreamPlayer = null

















var steps: Array = [
    {"sound": "res://assets/sounds/sfx/henshinsteps.wav"}, 
    {"bg": "res://assets/campaign/1henshin.png", "text": "This is it..."}, 
    {"text": "I've found it at last..."}, 
    {"text": "The forgotten treasure of the ancient sorcerers..."}, 
    {"bg": "res://assets/campaign/2henshin.png", "text": "Hahahahaha!"}, 
    {"text": "Hahahahha...\nHahahaha!!!"}, 
    {"bgm": "res://assets/sounds/bgm/pharaosplace.mp3", "bg": "res://assets/campaign/pharaosplace.png", 
    "char_img": "res://assets/chars/simonmuranfpbig.png", "show_char": true, 
    "clear_text": true, "text": "My dear prin..."}, 
    {"text": "Wait... You are not my prince."}, 
    {"text": "Who are you?"}, 
    {"text": "..."}, 
    {"text": "I see... You are [PlayerName]."}, 
    {"text": "Do you know how to play cards?"}, 
    {"text": "I've taught my prince to play cards, so I can teach you a thing or two.", "save": true}, 


    {"text": "What do you say?", "enemy": "Simon Muran", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Not bad at all! You already know quite a lot."}, 
    {"unlock_enemy": "Simon Muran", "text": "So... I will stay here, waiting for my prince.", "save": true}, 
    {"text": "See you soon!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bgm": "res://assets/sounds/bgm/duelground.mp3", "bg": "res://assets/campaign/duelground.png", 
    "char_img": "res://assets/chars/teanafpbig.png", "show_char": true, 
    "clear_text": true, "text": "Hello there!"}, 
    {"text": "I guess I've never seen you around..."}, 
    {"text": "Who are you?"}, 
    {"text": "Oh, [PlayerName], nice to meet you!"}, 
    {"text": "Me and Jono are waiting here for the prince to come."}, 
    {"text": "But Jono has left for a while.", "save": true}, 


    {"text": "In the meantime, how about a duel?", "enemy": "Teana", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Wow, you're strong!\nI lost..."}, 
    {"unlock_enemy": "Teana", "text": "I will duel you again when I get a little better.", "save": true}, 
    {"text": "See you later!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"text": "Wait!"}, 
    {"char_img": "res://assets/chars/villager1fpbig.png", "show_char": true, 
    "clear_text": true, "text": "Who are you?"}, 
    {"text": "Did you just beat Teana? I don't believe it."}, 
    {"text": "Y'know there is a festival going on in the Town Plaza."}, 
    {"text": "But we'd rather play games right here,\nlike we always do.", "save": true}, 


    {"text": "Wanna take me on?", "enemy": "Joseph", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Well, well...\nLet's play again sometime..."}, 
    {"unlock_enemy": "Joseph", "hide_char": true, "clear_text": true, "save": true}, 
    {"char_img": "res://assets/chars/villager2fpbig.png", "show_char": true, 
    "clear_text": true, "text": "Hey!\nDid you find yourself any rare cards?"}, 
    {"text": "I managed to find a pretty good card myself!"}, 
    {"text": "If you want it, you'll have to beat me."}, 
    {"text": "But if you lose, you'll have to give me one of yours.", "save": true}, 


    {"text": "What do you say?", "enemy": "Noah", "show_buttons": true}, 
    {"hide_buttons": true, "text": "You won...\nI guess I owe you a card.\nTake it."}, 
    {"unlock_enemy": "Noah", "hide_char": true, "clear_text": true, "save": true}, 
    {"char_img": "res://assets/chars/villager3fpbig.png", "show_char": true, 
    "text": "You talkin' to me, boy?\nI got better things to do.", "save": true}, 


    {"text": "Unless you wanna challenge me...", "enemy": "Issam", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Hmph!\nI reckon I lost..."}, 
    {"unlock_enemy": "Issam", "text": "Looks like this just isn't my day...", "save": true}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/teanafpbig.png", "enemy": "Teana", "show_char": true, 
    "text": "Hey, did you know that there's a festival going on in the Town Plaza?"}, 
    {"text": "Come on! Let's check it out!"}, 
    {"text": "I'll bet we'll find Jono there!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bgm": "res://assets/sounds/bgm/townplaza.mp3", "bg": "res://assets/campaign/townplaza.png", 
    "char_img": "res://assets/chars/teanafpbig.png", "enemy": "Teana", "show_char": true, 
    "clear_text": true, "text": "Wow...\nThere's a lot of people around."}, 
    {"text": "Look, the mages are about to start their procession..."}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/magesprocession.png", 
    "clear_text": true, "text": "[Teana]\nAwesome..."}, 
    {"text": "[Teana]\nBut... Kinda spooky, too."}, 
    {"text": "[Teana]\nThis must be the work of that detestable high mage, Heishin."}, 
    {"text": "[Teana]\nWhen I was a kid, it used to be more wholesome."}, 
    {"text": "[Teana]\nEven the attitude of the mages have changed for the worse..."}, 
    {"text": "[Teana]\nWhat's our world coming to...?"}, 
    {"clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/townplaza.png", 
    "char_img": "res://assets/chars/teanafpbig.png", "enemy": "Teana", "show_char": true, 
    "clear_text": true, "text": "Want to go someplace else?"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/jonovsseto.png", 
    "clear_text": true, "text": "[Teana]\nLook! It's Jono!\nI can't believe it, but he's dueling over there!"}, 
    {"text": "[Jono]\nI...\nI lost..."}, 
    {"text": "[Seto]\nI believe I have wasted my efforts on an insignificant speck."}, 
    {"text": "[Jono]\nSay what!"}, 
    {"text": "[Seto]\nForgive my choice of words.\nYou were... mildly entertaining."}, 
    {"text": "[Teana]\nHey! Jono!"}, 
    {"text": "[Jono]\nTeana and..."}, 
    {"clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/duelarena.png", 
    "char_img": "res://assets/chars/jonofpbig.png", "enemy": "Jono", "show_char": true, 
    "clear_text": true, "text": "[Teana]\nWhat's going on?"}, 
    {"text": "Whaddaya think?\nAin't it obvious?"}, 
    {"text": "[Teana]\nYou lost..."}, 
    {"text": "Don't be so blunt! I didn't lose... I had a setback..."}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/seto1fpbig.png", "enemy": "Seto 1", "show_char": true, 
    "clear_text": true, "text": "I grow weary of this insect..."}, 
    {"text": "Is there not one among you that is worthy of my attention?"}, 
    {"text": "[Jono]\nMan!\nThe nerve of this guy!"}, 
    {"text": "[Teana]\nHey, [PlayerName]...\nWhy don't you challenge him?"}, 
    {"text": "[Teana]\nAfter all, you're the best duelist I've ever seen!"}, 
    {"text": "[Teana]\nI'll bet you can beat him!"}, 
    {"text": "[Jono]\nYeah, [PlayerName]!\nDo it! Show him who's boss around here!"}, 
    {"text": "Hello...\nAre you my next victim?"}, 
    {"text": "I hope you are better than the last one.\nCome! Let us duel."}, 
    {"text": "[???]\nMaster Seto! Master Heishin calls for you."}, 
    {"text": "I see..."}, 
    {"text": "So be it.\nThe duel is postponed."}, 
    {"text": "Am I correct in assuming that you frequent the town's duel field?"}, 
    {"text": "[Jono]\nThat's right."}, 
    {"text": "Then wait there...\nI shall grace you with a visit."}, 
    {"text": "Seto is my name.\nRemember it..."}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/jonofpbig.png", "enemy": "Jono", "show_char": true, 
    "clear_text": true, "text": "Can you believe that guy!?\nA mage with attitude!!!"}, 
    {"text": "[Teana]\nYeah... A real charmer."}, 
    {"text": "I got a feeling [PlayerName] will put him in his place.\nWon't ya, buddy?"}, 
    {"text": "C'mon, let's look around and then head for the duel field."}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bgm": "res://assets/sounds/bgm/duelground.mp3", "bg": "res://assets/campaign/duelground.png", 
    "char_img": "res://assets/chars/jonofpbig.png", "show_char": true, 
    "clear_text": true, "text": "Geez... Who does that mage think he is anyway!?"}, 
    {"text": "I gotta admit, though... that guy was real tough...", "save": true}, 


    {"text": "Hey, [PlayerName],\nHow about a game until that guy comes back?", "enemy": "Jono", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Geez, [PlayerName]!\nYou whipped me!\nY'know... you are good!"}, 
    {"unlock_enemy": "Jono", "text": "Do me a favor and beat that mage, willya?", "save": true}, 
    {"text": "There he is...\nHe's back."}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/setoandmages.png", 
    "clear_text": true, "text": "[Jono]\nLook at that...\nHe's got his own groupies..."}, 
    {"text": "[Jono]\nDo me a favor and whip the guy."}, 
    {"text": "[Teana]\nDo it, [PlayerName]!"}, 
    {"clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/duelground.png", "char_img": "res://assets/chars/seto1fpbig.png", 
    "show_char": true, 
    "clear_text": true, "text": "I do not know how good you are...\nBut I hope you will entertain me."}, 
    {"text": "I will have you know that I enjoy a good game...", "save": true}, 


    {"text": "Do not disappoint me!", "enemy": "Seto 1", "show_buttons": true}, 
    {"hide_buttons": true, "text": "But... wait a moment.\nYou... you are..."}, 
    {"unlock_enemy": "Seto 1", "text": "Hmmm... I see...", "save": true}, 
    {"text": "Enough.\nThat is all for today."}, 
    {"text": "I have a feeling our paths will cross elsewhere..."}, 
    {"text": "'Till then... I bid you farewell."}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/jonofpbig.png", "show_char": true, 
    "text": "You did it!\n[PlayerName]."}, 
    {"text": "Didja see the look on his face!? You were great!!!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/teanafpbig.png", "show_char": true, 
    "text": "[PlayerName]...\nYou're just too good!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/jonofpbig.png", "show_char": true, 
    "text": "'I bid you farewell'...\nHah! What a loser!"}, 
    {"text": "[PlayerName],\nWell, what now?"}, 
    {"text": "You still got some time?"}, 
    {"text": "If you need to go, it's ok."}, 
    {"text": "Yeah? Well, come around again any time..."}, 
    {"text": "We'll be here."}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bgm": "res://assets/sounds/bgm/pharaosplace.mp3", "bg": "res://assets/campaign/magesreunion.png", 
    "text": "[Unknown Mage 1]\nWhere is Seto?"}, 
    {"text": "[Unknown Mage 2]\nMust we be kept waiting!?"}, 
    {"text": "[Unknown Mage 3]\nWhere can he be at a time like this!?"}, 
    {"text": "[Unknown Mage 3]\nT'would seem Master Heishin's favorite chooses to mock us..."}, 
    {"text": "[Unknown Mage 4]\nMaster Heishin dos make much of Seto's capabilities..."}, 
    {"text": "[Unknown Mage 4]\n...though he is but a child."}, 
    {"text": "[Unknown Mage 5]\nI believe we've waited enough. Let us go. Master Heishin awaits us..."}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bgm": "res://assets/sounds/bgm/pharaosplace.mp3", "bg": "res://assets/campaign/pharaosplace.png", 
    "char_img": "res://assets/chars/simonmuranfpbig.png", "show_char": true, 
    "text": "Well, it's about time! Are you going to rest now?"}, 
    {"text": "See you tomorrow then."}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bgm": "res://assets/sounds/bgm/pharaosplace.mp3", "bg": "res://assets/campaign/simonmuranthinks.png", 
    "text": "[Simon Muran]\nSometimes I wonder if everyone here just does things to annoy me..."}, 
    {"text": "[Guard]\nLord Simon Muran!\nWe've got trouble!"}, 
    {"text": "[Guard]\nTh-the High Mage... The High Mage Heishin and his men..."}, 
    {"text": "[Guard]\nThey wield a strange power... They're invading the palace!!!"}, 
    {"text": "[Simon Muran]\nWhat!?"}, 
    {"bgm": "res://assets/sounds/bgm/heishininvasion.mp3", 
    "text": "[Guard]\nI think it's sorcery, my lord!\nI'm afraid there's naught we can do to fend them off..."}, 
    {"text": "[Simon Muran]\nWhere's the High Mage now!?"}, 
    {"text": "[Guard]\nIn the Palace Hall, my lord!"}, 
    {"text": "[Simon Muran]\nHeishin... Heishin!\nWhat could that dog have in mind?"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/destroyedhall.png", 
    "text": "[Simon Muran]\nWha... What the..."}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/heishin1fpbig.png", "show_char": true, 
    "text": "It's good to see you again, Simon Muran..."}, 
    {"text": "[Simon Muran]\nYou dare to revolt...\nAre you mad!?"}, 
    {"text": "Mad...?\nMe?"}, 
    {"text": "I don't think so...\nI've but come to claim my throne."}, 
    {"text": "[Simon Muran]\nYour throne!?"}, 
    {"text": "Yes, my throne. For I now have the 'Power'..."}, 
    {"text": "[Simon Muran]\nThe 'Power'...\nNo... It cannot be..."}, 
    {"text": "I see recognition in your eyes. But then we both draw roots from our sorcerous forefathers..."}, 
    {"text": "[Simon Muran]\nThe power of darkness...!?"}, 
    {"text": "That's right. I've discovered the forgotten treasure..."}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/henshinpower.png", 
    "text": "Here! Taste the forgotten power of darkness!!!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/royalchamber.png", 
    "char_img": "res://assets/chars/saheenfpbig.png", "show_char": true, 
    "text": "Help! I can't find our Prince."}, 
    {"text": "He must have escaped already."}, 
    {"text": "The High Mage Heishin has invaded the palace!"}, 
    {"text": "This place is too dangerous!\nWe must leave at once!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bgm": "res://assets/sounds/bgm/setosbetrayal.mp3", "bg": "res://assets/campaign/setosbetrayal.png", 
    "text": "[Saheen]\nNo..."}, 
    {"text": "[Seto]\nThe Prince must have escaped, but you won't."}, 
    {"text": "[Seto]\nAnd so we meet again..."}, 
    {"text": "[Seto]\nAll right men...\nAway with this servant!"}, 
    {"text": "[Seto]\nI wish to speak with the prince, or whoever can send him a message."}, 
    {"text": "[Seto's Guard]\nBy your command!"}, 
    {"text": "[Saheen]\nPlease help!"}, 
    {"text": "[Seto's Guard]\nBe quiet and come with us!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/palacealley.png", 
    "char_img": "res://assets/chars/seto1fpbig.png", "show_char": true, 
    "text": "Where you think you are going?"}, 
    {"text": "Trying to reach for the prince, [PlayerName]?"}, 
    {"text": "Heishin already holds the King and Queen captive."}, 
    {"text": "Running away would only provoke Heishin to end their lives..."}, 
    {"text": "Is that what you want?"}, 
    {"text": "Well... I'll tell you what I want. Something that only one of royal blood would know..."}, 
    {"text": "...the location of the Millenium Item."}, 
    {"text": "Tell me where it is and I'll spare the King and Queen!"}, 
    {"text": "You were wandering with these people..."}, 
    {"text": "So you must know where it is!\nSo... Tell me!"}, 
    {"text": "[Simon Muran]\n[PlayerName]..."}, 
    {"text": "Simon Muran!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/simonwithpuzzle.png", 
    "text": "[Simon Muran]\nDear [PlayerName]...\nHere is the Millenium Item..."}, 
    {"text": "[Simon Muran]\nMy prince tried to bait them, so he ran away and left the Millenium Item behind..."}, 
    {"text": "[Simon Muran]\nTake it... Take it and run!!!"}, 
    {"text": "[PlayerName] GETS THE MILLENIUM PUZZLE!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/palacealley.png", 
    "char_img": "res://assets/chars/simonmuranfpbig.png", "show_char": true, 
    "text": "You must keep this treasure from falling into the hands of these vermin!!!"}, 
    {"text": "The treasure is the final key to unlocking the seal to great power."}, 
    {"text": "Should it fall in the hands of the wicked, it would mean armageddon..."}, 
    {"text": "[Seto]\nWell, well... You couldn't have brought it at a better time."}, 
    {"text": "[Seto]\nHand the key over to me right now, and I might help the two of you escape from Heishin."}, 
    {"text": "Ignore this cur! He wags his tail at Heishin's command! He's not to be trusted!"}, 
    {"text": "Leave him to me, [PlayerName]!\nYou must escape!"}, 
    {"text": "[Seto]\nOut of my way, old man!"}, 
    {"text": "Go, [PlayerName]! Run!"}, 
    {"text": "Listen to what I say...\nGet out of here!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bgm": "res://assets/sounds/bgm/heishininvasion.mp3", "bg": "res://assets/campaign/palacealley.png", 
    "char_img": "res://assets/chars/heishin1fpbig.png", "show_char": true, 
    "text": "Do not move! You are mine!"}, 
    {"text": "I see you've found them, Seto. Well done."}, 
    {"text": "[Seto]\nYes, my lord..."}, 
    {"text": "You didn't think you'd escape me, did you?"}, 
    {"text": "There's no point in resisting. Admit your defeat..."}, 
    {"text": "...and hand it over. Give me the Millennium Item!!!"}, 
    {"text": "[Simon Muran]\nOnly one option remains, [PlayerName].", "save": true}, 


    {"text": "[Simon Muran]\nYou must do battle with Heishin. Challenge him to a duel with your cards trust in yourself!", 
    "enemy": "Heishin 1", "show_buttons": true}, 
    {"hide_buttons": true, 
    "text": "Not bad boy.", "save": true}, 
    {"text": "But you are wrong if you think I'm beaten.", "show_buttons": true}, 
    {"hide_buttons": true, 
    "text": "Foolish child! You may think you are good, but you just wasted my time!"}, 
    {"unlock_enemy": "Heishin 1", "text": "If you insist on keeping the Millennium Puzzle, I'll just rip it from you lifeless fingers!", "save": true}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/simonvsheishin.png", "bgm": "res://assets/sounds/bgm/heishinmillennium.mp3", 
    "text": "[Heishin]\n!!!"}, 
    {"text": "[Heishin]\nOut of my way, old man! Or else..."}, 
    {"text": "[Simon Muran]\n[PlayerName]! Shatter the Millennium Puzzle..."}, 
    {"text": "[Simon Muran]\nYou must not had it over to this vile creature!"}, 
    {"text": "[Heishin]\nOut of my way, old man! Get your hands off me!"}, 
    {"text": "[Simon Muran]\n[PlayerName]... The puzzle..."}, 
    {"text": "[Simon Muran]\n...don't give them the puzzle..."}, 
    {"text": "[Simon Muran]\nShatter it!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/shatteredpuzzle.png", "sound": "res://assets/sounds/sfx/shatter.wav", 
    "text": "[Heishin]\nNo!!!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/insidepuzzle.png", "bgm": "res://assets/sounds/bgm/insidethepuzzle.mp3", 
    "char_img": "res://assets/chars/simonmuranfpbig.png", "show_char": true, 
    "text": "[PlayerName]..."}, 
    {"text": "!?"}, 
    {"text": "Thank goodness! You've awoken! We're inside the Millennium Puzzle."}, 
    {"text": "To be precise, your soul is now sealed within the puzzle."}, 
    {"text": "I'm sorry, [PlayerName]. But this was the only way I could save you and the puzzle."}, 
    {"text": "I couldn't allow you to simply hand over the puzzle to the likes of Heishin."}, 
    {"text": "The power of darkness that Heishin sought to unravel could only lead to destruction."}, 
    {"text": "One day, when someone puts the puzzle together again, you will live to walk among men."}, 
    {"text": "Until that day comes... Sleep, [PlayerName]."}, 
    {"text": "I'm sure there is someone out there destined to assemble the puzzle."}, 
    {"text": "In the end, that person and the Millennium Puzzle will guide you back to our world."}, 
    {"text": "Now rest, [PlayerName]... Close your eyes..."}, 
    {"hide_char": true, "clear_text": true, "save": true}, 


    {"fade_screen": true, "bg": "res://assets/campaign/classroom.png", "bgm": "res://assets/sounds/bgm/moderntimes.mp3", 
    "char_img": "res://assets/chars/joeywheelerfpbig.png", "show_char": true, 
    "text": "Hey!\nWake up!"}, 
    {"text": "You are the new student, right?"}, 
    {"text": "My name is Joey Wheeler, nice to meet ya!"}, 
    {"text": "And you are [PlayerName], right?"}, 
    {"text": "Yugi and Tea already left for the opening ceremony."}, 
    {"text": "Let's go!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/tournamentannouncement.png", "bgm": "res://assets/sounds/bgm/tournamentannouncement.mp3", 
    "text": "[Commentator]\nWelcome to Yu-Gi-Oh! World Tournament!"}, 
    {"text": "[Commentator]\nSponsored by the Kaiba Corporation!"}, 
    {"text": "[Commentator]\nWe're now at the TOWN OF DOMINO where selected duelists have gathered to decide who is number one!"}, 
    {"text": "[Joey]\nThis is it, [PlayerName]!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/tournament.png", 
    "char_img": "res://assets/chars/commentatorfpbig.png", "show_char": true, 
    "text": "The battles are about to begin..."}, 
    {"text": "But before we start, there are a few rules to explain..."}, 
    {"text": "Tournament rules are divided between the preliminar and the finals. For example..."}, 
    {"text": "[Joey]\nWho care about the rules. All you gotta do is keep winning!"}, 
    {"text": "[Joey]\nRight, [PlayerName]?"}, 
    {"text": "...and now, a few words from our sponsor, Mr. Kaiba!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/setokaibafpbig.png", "show_char": true, 
    "text": "I thank you for joining us in deciding the king of kings..."}, 
    {"text": "Today we duel to decide who is the Game Master... The ultimate duelist!"}, 
    {"text": "And I, too, am intent upon winning that honor..."}, 
    {"text": "[Joey]\nThat Kaiba gets on my nerves!"}, 
    {"text": "[Joey]\nIf anybody puts him out of the tournament, I hope it's me!"}, 
    {"text": "[Joey]\n[PlayerName], I'm hoping to face you in the finals... Okay?"}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/commentatorfpbig.png", "show_char": true, 
    "text": "All right then, ladies and gentlemen! May the best man win! Let the duels begin!!!"}, 
    {"text": "Hey! Pssst..."}, 
    {"text": "You are new around here, right?"}, 
    {"text": "Come closer, I want to talk with you."}, 
    {"text": "You know... I'm not a big duelist myself, but I have a prepared deck with me."}, 
    {"text": "And I saw that you are going to participate in this tournament.", "save": true}, 


    {"text": "So, how about a duel? Just to test out my deck, you know.", "enemy": "Commentator", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Hmmm... Maybe my deck isn't good enough yet."}, 
    {"unlock_enemy": "Commentator", "text": "See you later!", "save": true}, 
    {"hide_char": true, "clear_text": true}, 
    {"bgm": "res://assets/sounds/bgm/tea&yugitheme.mp3", "char_img": "res://assets/chars/teagardnerfpbig.png", "show_char": true, 
    "text": "Hey! You are the new student, right?"}, 
    {"text": "Me and Yugi are around here too, but we won't participate in this tournament."}, 
    {"text": "But we can help you testing your deck before you go into the tournament...", "save": true}, 


    {"text": "How about that?", "enemy": "Tea Gardner", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Ok... Not bad at all! You sure have a chance in this tournament!"}, 
    {"unlock_enemy": "Tea Gardner", "text": "Good luck beating Yugi.", "save": true}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/yugimutofpbig.png", "show_char": true, 
    "text": "Wow you beat Tea... You must be a great duelist!"}, 
    {"text": "But if you want to, I can help you by testing your deck too before you go into the tournament.", "save": true}, 


    {"text": "What do you say?", "enemy": "Yugi Muto", "show_buttons": true}, 
    {"hide_buttons": true, "text": "I must say, your deck is really good!"}, 
    {"unlock_enemy": "Yugi Muto", "text": "My name is Yugi by the way. Nice to meet you!", "save": true}, 
    {"text": "See ya! And good luck in the tournament!"}, 
    {"hide_char": true, "clear_text": true}, 
    {"fade_screen": true, "bg": "res://assets/campaign/tournamentroom.png", "bgm": "res://assets/sounds/bgm/preliminaryfaceoff.mp3", 
    "text": "[Commentator]\nPreliminary Match 1!\n[PlayerName] vs Jonathan Bicalho!", "char_img": "res://assets/chars/jonathanbicalhofpbig.png"}, 
    {"show_char": true, 
    "text": "Hey! Nice to meet you.", "save": true}, 


    {"text": "You better be ready to face me!", "enemy": "Jonathan Bicalho", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Ok, you deserved it. Good luck on your next duel."}, 
    {"unlock_enemy": "Jonathan Bicalho", "text": "I'll be watching you... See ya!", "save": true}, 
    {"hide_char": true, "clear_text": true}, 
    {"bgm": "res://assets/sounds/bgm/keithunderwoodraptorbonztheme.mp3", "char_img": "res://assets/chars/rexraptorfpbig.png", 
    "text": "[Commentator]\nPreliminary Match 2!\n[PlayerName] vs Rex Raptor!"}, 
    {"show_char": true, 
    "text": "Heh... Heard you are new around here."}, 


    {"text": "But it does't matter... I guess you're gonna be watching me in the finals.", "enemy": "Rex Raptor", "show_buttons": true}, 
    {"hide_buttons": true, "text": "You... You beat me!!!"}, 
    {"unlock_enemy": "Rex Raptor", "text": "I don't believe it!!!", "save": true}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/weevilunderwoodfpbig.png", 
    "text": "[Commentator]\nPreliminary Match 3!\n[PlayerName] vs Weevil Underwood!"}, 
    {"show_char": true, 
    "text": "Hmmm... So you beat Rex... Not bad... Not bad at all."}, 


    {"text": "But let's see if you can handle all my insects!\nYahahahah!!", "enemy": "Weevil Underwood", "show_buttons": true}, 
    {"hide_buttons": true, "text": "You fool! We need to duel again!!"}, 
    {"unlock_enemy": "Weevil Underwood", "text": "Aaarrgh!!!", "save": true}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/banditkeithfpbig.png", 
    "text": "[Commentator]\nPreliminary Match 4!\n[PlayerName] vs Bandit Keith!"}, 
    {"show_char": true, 
    "text": "I saw some people here talking about you..."}, 


    {"text": "But I came here to bury you, [PlayerName]!", "enemy": "Bandit Keith", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Me... The Card Professor..."}, 
    {"unlock_enemy": "Bandit Keith", "text": "Beaten by this newcomer!", "save": true}, 
    {"hide_char": true, "clear_text": true}, 
    {"char_img": "res://assets/chars/bonzfpbig.png", 
    "text": "[Commentator]\nPreliminary Match 5!\n[PlayerName] vs Bonz!"}, 
    {"show_char": true, 
    "text": "You can't beat my boss and get away!"}, 


    {"text": "Now it's me and you... And my zombies!!!\nHeh heh heh heh...", "enemy": "Bonz", "show_buttons": true}, 
    {"hide_buttons": true, "text": "Ahhhhhhhhhh! Oh no! I lost!"}, 
    {"unlock_enemy": "Bonz", "text": "Bandit Keith, wait for me!!! Boss!!!", "save": true}, 
    {"hide_char": true, "clear_text": true, "menu": true}, 

    ]

func _ready() -> void :

    char_box_original_pos = char_box.position


    char_box.visible = false
    buttons.visible = false
    text_label.text = ""
    text_label.visible_ratio = 1.0


    fade_rect.visible = true
    fade_rect.color = Color(0, 0, 0, 1)


    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        current_step = global.campaign_step


    last_click_time = Time.get_ticks_msec()


    _setup_button_hover_effects()


    if current_step > 0:
        _restore_state_up_to(current_step)


    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 1.0)
    tween.tween_callback( func():

        fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

        _execute_step(current_step)
    )


func _restore_state_up_to(step: int) -> void :
    "Restaura o estado visual de todos os passos anteriores sem animação"
    var last_bgm = ""
    var last_char_img = ""
    var last_enemy = "Simon Muran"
    for i in range(step):
        var s = steps[i]
        if s.has("bgm"):
            last_bgm = s["bgm"]
        if s.has("bg"):
            var tex = load(s["bg"])
            if tex:
                background.texture = tex
        if s.has("char_img"):
            last_char_img = s["char_img"]
        if s.has("enemy"):
            last_enemy = s["enemy"]
        if s.has("show_char") and s["show_char"]:
            char_box.visible = true
            char_box.position = char_box_original_pos


    current_enemy = last_enemy
    if last_char_img != "":
        var tex = load(last_char_img)
        if tex:
            char_box.texture = tex


    if last_bgm != "":
        _play_bgm(last_bgm)


    text_label.text = ""


func _execute_step(step_index: int) -> void :
    if step_index < 0 or step_index >= steps.size():
        return

    var step = steps[step_index]
    is_animating = true


    if step.has("fade_screen") and step["fade_screen"]:
        fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
        var fade_tween = create_tween()
        fade_tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
        fade_tween.tween_callback( func():

            _apply_step_changes(step)


            var fade_in_tween = create_tween()
            fade_in_tween.tween_property(fade_rect, "color", Color(0, 0, 0, 0), 1.0)
            fade_in_tween.tween_callback( func():
                fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
                _process_step_animations(step)
            )
        )
        return


    _apply_step_changes(step)
    _process_step_animations(step)

func _apply_step_changes(step: Dictionary) -> void :

    if step.has("sound"):
        _play_sfx(step["sound"])


    if step.has("bgm"):
        _play_bgm(step["bgm"])


    if step.has("bg"):
        var tex = load(step["bg"])
        if tex:
            background.texture = tex


    if step.has("enemy"):
        current_enemy = step["enemy"]


    if step.has("hide_buttons") and step["hide_buttons"]:
        buttons.visible = false
        buttons_visible = false


    if step.has("unlock_enemy") and has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.unlock_duelist(step["unlock_enemy"])


    if (step.has("save") and step["save"]):
        if has_node("/root/Global"):
            var global = get_node("/root/Global")
            global.campaign_step = current_step
            global.save_player_data()
            print("Progresso da campanha salvo no step: ", current_step)


    if step.has("char_img") and not step.has("show_char") and not step.has("hide_char"):
        var tex = load(step["char_img"])
        if tex:
            char_box.texture = tex


    if step.has("clear_text") and step["clear_text"]:
        text_label.text = ""
        text_label.visible_ratio = 1.0


    if step.has("menu") and step["menu"]:
        _show_menu_overlay()

func _process_step_animations(step: Dictionary) -> void :

    var has_anim = false

    if step.has("hide_char") and step["hide_char"] and char_box.visible:
        has_anim = true
        var off_screen_x = - char_box.size.x - 100

        var hide_tween = create_tween()
        hide_tween.set_trans(Tween.TRANS_CUBIC)
        hide_tween.set_ease(Tween.EASE_IN)
        hide_tween.tween_property(char_box, "position:x", off_screen_x, 0.4)
        hide_tween.tween_callback( func():
            char_box.visible = false

            if step.has("show_char") and step["show_char"]:
                _do_show_char_anim(step)
            else:
                if step.has("text"):
                    _typewriter_text(step["text"], step.has("show_buttons") and step["show_buttons"])
                else:
                    _finish_step(step)
        )
    elif step.has("show_char") and step["show_char"]:
        has_anim = true
        _do_show_char_anim(step)

    if has_anim:
        return


    if step.has("text"):
        _typewriter_text(step["text"], step.has("show_buttons") and step["show_buttons"])
        return


    _finish_step(step)

func _do_show_char_anim(step: Dictionary) -> void :

    if step.has("char_img"):
        var tex = load(step["char_img"])
        if tex:
            char_box.texture = tex

    char_box.visible = true

    var off_screen_x = - char_box.size.x - 100
    char_box.position.x = off_screen_x
    char_box.position.y = char_box_original_pos.y

    var slide_tween = create_tween()
    slide_tween.set_trans(Tween.TRANS_CUBIC)
    slide_tween.set_ease(Tween.EASE_OUT)
    slide_tween.tween_property(char_box, "position:x", char_box_original_pos.x, 0.5)
    slide_tween.tween_callback( func():

        if step.has("text"):
            _typewriter_text(step["text"], step.has("show_buttons") and step["show_buttons"])
        else:
            _finish_step(step)
    )

func _typewriter_text(text: String, show_buttons_after: bool = false) -> void :
    var final_text = text
    if "[PlayerName]" in final_text and has_node("/root/Global"):
        var global = get_node("/root/Global")
        final_text = final_text.replace("[PlayerName]", global.player_name)

    text_label.text = final_text
    text_label.visible_ratio = 0.0

    var tween = create_tween()
    tween.tween_property(text_label, "visible_ratio", 1.0, 1.0)
    tween.tween_callback( func():
        if show_buttons_after:
            buttons.visible = true
            buttons_visible = true

            buttons.modulate = Color(1, 1, 1, 0)
            var btn_tween = create_tween()
            btn_tween.tween_property(buttons, "modulate", Color(1, 1, 1, 1), 0.3)
            btn_tween.tween_callback( func():
                is_animating = false
            )
        else:
            is_animating = false
    )

func _finish_step(step: Dictionary) -> void :
    if step.has("show_buttons") and step["show_buttons"]:
        buttons.visible = true
        buttons_visible = true
    elif step.has("hide_buttons") and step["hide_buttons"]:
        buttons.visible = false
        buttons_visible = false

    is_animating = false


func _input(event) -> void :
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

        if input_locked:
            return


        if is_animating or buttons_visible:
            return


        var current_time = Time.get_ticks_msec()
        if current_time - last_click_time < 900:
            return

        last_click_time = current_time


        if buttons.visible:
            return


        current_step += 1
        if current_step < steps.size():
            _play_click_sound()
            _execute_step(current_step)


func _on_duel_pressed() -> void :
    if input_locked: return
    input_locked = true
    _play_confirm_sound()
    if has_node("/root/Global"):
        var global = get_node("/root/Global")
        global.next_enemy_deck_key = current_enemy
        global.is_campaign_duel = true
        global.campaign_return_step = current_step + 1


    buttons.visible = false
    buttons_visible = false


    fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
    tween.tween_callback( func():
        if has_node("/root/SceneManage"):
            var scene_manager = get_node("/root/SceneManage")
            scene_manager.change_scene("res://scenes/duel/duel.tscn")
        else:
            get_tree().change_scene_to_file("res://scenes/duel/duel.tscn")
    )

func _on_build_deck_pressed() -> void :
    if input_locked: return
    input_locked = true
    _play_confirm_sound()
    fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
    tween.tween_callback( func():
        if has_node("/root/SceneManage"):
            var scene_manager = get_node("/root/SceneManage")
            scene_manager.change_scene("res://scenes/deck_builder/DeckBuilder.tscn")
        else:
            get_tree().change_scene_to_file("res://scenes/deck_builder/DeckBuilder.tscn")
    )

func _on_menu_pressed() -> void :
    if input_locked: return
    input_locked = true
    _play_confirm_sound()
    fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP
    var tween = create_tween()
    tween.tween_property(fade_rect, "color", Color(0, 0, 0, 1), 1.0)
    tween.tween_callback( func():
        if has_node("/root/SceneManage"):
            var scene_manager = get_node("/root/SceneManage")
            scene_manager.change_scene("res://main_menu.tscn", false)
        else:
            get_tree().change_scene_to_file("res://main_menu.tscn")
    )

func _show_menu_overlay() -> void :
    input_locked = true

    var canvas = CanvasLayer.new()
    canvas.layer = 100
    add_child(canvas)


    var panel = PanelContainer.new()
    panel.set_anchors_preset(Control.PRESET_CENTER)
    panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
    panel.grow_vertical = Control.GROW_DIRECTION_BOTH

    var style = StyleBoxFlat.new()
    style.bg_color = Color(0, 0, 0, 1)
    style.border_width_left = 4
    style.border_width_top = 4
    style.border_width_right = 4
    style.border_width_bottom = 4
    style.border_color = Color(1, 1, 1, 1)
    panel.add_theme_stylebox_override("panel", style)
    canvas.add_child(panel)

    var margin = MarginContainer.new()
    margin.add_theme_constant_override("margin_left", 60)
    margin.add_theme_constant_override("margin_top", 40)
    margin.add_theme_constant_override("margin_right", 60)
    margin.add_theme_constant_override("margin_bottom", 40)
    panel.add_child(margin)

    var vbox = VBoxContainer.new()
    vbox.add_theme_constant_override("separation", 30)
    margin.add_child(vbox)


    var label = Label.new()
    label.text = "To be continued..."
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

    var matrix_font = load("res://assets/fonts/MatrixSmallCaps Bold.ttf")
    if matrix_font:
        label.add_theme_font_override("font", matrix_font)
    label.add_theme_font_size_override("font_size", 48)
    label.add_theme_color_override("font_color", Color.WHITE)
    vbox.add_child(label)


    var btn = Button.new()
    btn.text = "Return to Menu"
    btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
    btn.custom_minimum_size = Vector2(200, 60)

    if matrix_font:
        btn.add_theme_font_override("font", matrix_font)
    btn.add_theme_font_size_override("font_size", 32)
    btn.add_theme_color_override("font_color", Color.WHITE)


    var btn_normal = StyleBoxFlat.new()
    btn_normal.bg_color = Color(0, 0, 0, 1)
    btn_normal.border_width_left = 2
    btn_normal.border_width_top = 2
    btn_normal.border_width_right = 2
    btn_normal.border_width_bottom = 2
    btn_normal.border_color = Color(1, 1, 1, 1)

    var btn_hover = btn_normal.duplicate()
    btn_hover.bg_color = Color(0.2, 0.2, 0.2, 1)

    btn.add_theme_stylebox_override("normal", btn_normal)
    btn.add_theme_stylebox_override("hover", btn_hover)
    btn.add_theme_stylebox_override("pressed", btn_hover)
    btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())

    btn.pressed.connect( func():
        _play_confirm_sound()
        if has_node("/root/SceneManage"):
            get_node("/root/SceneManage").change_scene("res://main_menu.tscn", false)
        else:
            get_tree().change_scene_to_file("res://main_menu.tscn")
    )
    vbox.add_child(btn)


    canvas.offset.y = 50
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(panel, "modulate:a", 1.0, 0.5).from(0.0)
    tween.tween_property(canvas, "offset:y", 0.0, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _play_sfx(path: String) -> void :
    if ResourceLoader.exists(path):
        var stream = load(path)
        if stream:
            sfx_player.stream = stream
            sfx_player.play()

func _play_bgm(path: String) -> void :
    if ResourceLoader.exists(path):
        var stream = load(path)
        if stream:
            stream.loop = true
            bgm_player.stream = stream
            bgm_player.bus = "Master"
            bgm_player.play()

func _play_confirm_sound() -> void :
    var sound_path = "res://assets/sounds/sfx/confirmbutton.wav"
    if ResourceLoader.exists(sound_path):
        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)
        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()

func _play_click_sound() -> void :
    var sound_path = "res://assets/sounds/sfx/click.wav"
    if ResourceLoader.exists(sound_path):
        if audio_player == null:
            audio_player = AudioStreamPlayer.new()
            add_child(audio_player)
        var stream = load(sound_path)
        audio_player.stream = stream
        audio_player.play()


func _setup_button_hover_effects() -> void :
    for child in buttons.get_children():
        if child is Button:
            child.focus_mode = Control.FOCUS_NONE
            child.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
            child.mouse_entered.connect(_on_button_hover.bind(child))
            child.mouse_exited.connect(_on_button_unhover.bind(child))

func _on_button_hover(button: Button) -> void :
    if not button.disabled:
        var tween = create_tween()
        tween.tween_property(button, "modulate", Color(0.393, 0.393, 0.393, 1.0), 0.1)

func _on_button_unhover(button: Button) -> void :
    if not button.disabled:
        var tween = create_tween()
        tween.tween_property(button, "modulate", Color.WHITE, 0.1)
