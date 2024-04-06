// Global variable to store remaining time
var remainingTime = 120; // 2 minutes

// Function to update the timer display
function updateTimer() {
    var minutes = Math.floor(remainingTime / 60);
    var seconds = remainingTime % 60;
    $('#timer-value').text(minutes + ':' + (seconds < 10 ? '0' : '') + seconds);
}

// Function to start the timer
function startTimer() {
    var countdown = setInterval(function() {
        remainingTime--;

        if (remainingTime < 0) {
            clearInterval(countdown);
            $('#timer-value').text('0:00'); // Display 0:00 when time's up
            endGame(); // Automatically end the game when time's up
        } else {
            updateTimer(); // Update timer display
        }
    }, 1000);
}

// Call startTimer function when the page loads
startTimer();

// Function to start a new game
function startGame() {
    $.ajax({
        url: '/start-game',
        type: 'GET',
        success: function(response) {
            $('#number-display').text('Numbers:');
            $('#number-buttons').empty(); // Clear previous buttons

            // Create clickable buttons for each number
            response.numbers.forEach(function(number) {
                var button = $('<button>').text(number).addClass('number-btn');
                $('#number-buttons').append(button);
            });
        }
    });
}

// Call startGame function when the page loads
startGame();

// Event listener for number buttons
$(document).on('click', '.number-btn', function() {
    var selectedNumber = $(this).text();

    // Check the answer immediately
    checkAnswer(selectedNumber);
});

// Function to check the answer
function checkAnswer(answer) {
    $.ajax({
        url: '/check-answer',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ answer: answer }),
        success: function(response) {
            $('#result').text(response.message);
            startGame(); // Start a new game after displaying the result
        }
    });
}
// Function to end the game and display final score and number of answers
function endGame() {
    $.ajax({
        url: '/end-game',
        type: 'GET',
        success: function(response) {
            $('#result').text('Final Score: ' + response.score);
            $('#score-info').text('Number of Answers: ' + response.num_clicks);
            $('#accuracy-rate').text('Accuracy Rate: ' + response.accuracy_rate.toFixed(2) + '%');
            $('#game-container').hide();
        }
    });
}
// Update the event listener for the submit button
$('#submit-btn').click(function() {
    endGame(); // Call endGame function when the button is clicked
});
