extends Label  # Change this to the appropriate node type if needed

@onready var timer_label = self  # Adjust the path to your Label node
var time_passed: float = 0.0  # Timer variable

func _ready():
	timer_label.text = "0"  # Initialize label text

func _process(delta):
	time_passed += delta  # Increment the timer
	timer_label.text = str(int(time_passed))  # Update label with elapsed time
