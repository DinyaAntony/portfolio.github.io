from flask import Flask, jsonify, request, session
import random

app = Flask(__name__, static_url_path='', static_folder='static')
app.secret_key = 'Jesus456#'  # Set a secure secret key for session management

@app.route('/start-game', methods=['GET'])
def start_game():
    # Generate three random numbers
    numbers = [random.randint(1, 25) for _ in range(3)]
    
    # Calculate the median
    median = sorted(numbers)[1]
    
    # Store the game data in a session
    session['numbers'] = numbers
    session['median'] = median
    
    # Return the numbers to the frontend
    return jsonify({'numbers': numbers})

@app.route('/end-game', methods=['GET'])
def end_game():
    # Retrieve the user's score, number of clicks, and number of correct answers from the session
    score = session.get('score', 0)
    num_clicks = session.get('num_clicks', 0)
    num_correct_answers = session.get('num_correct_answers', 0)
    
    # Calculate accuracy rate
    accuracy_rate = (num_correct_answers / num_clicks) * 100 if num_clicks > 0 else 0
    
    # Clear the session to reset the game
    session.clear()

    # Return the final score, number of clicks, and accuracy rate to the frontend
    return jsonify({'score': score, 'num_clicks': num_clicks, 'accuracy_rate': accuracy_rate})


@app.route('/check-answer', methods=['POST'])
def check_answer():
    # Get the user's answer from the request data
    user_answer = request.json.get('answer')

    # Retrieve the correct answer from the session
    correct_answer = max(session['numbers'], key=lambda x: abs(x - session['median']))
    
    # Initialize score if not present in the session
    if 'score' not in session:
        session['score'] = 0
        session['num_clicks'] = 0
        session['num_correct_answers'] = 0

    # Check if the user's answer matches the correct answer
    if int(user_answer) == correct_answer:
        message = 'Correct! +1 point'
        session['score'] += 1
        session['num_correct_answers'] += 1
        session['num_clicks'] += 1
    else:
        message = 'Wrong! -0.5 point'
        session['score'] -= 0.5
        session['num_clicks'] += 1
    
    # Return the result message, score, and accuracy rate to the frontend
    return jsonify({
        'message': message,
        'score': session['score'],
        'num_clicks': session['num_clicks'],
        'accuracy_rate': (session['num_correct_answers'] / session['num_clicks']) * 100 if session['num_clicks'] > 0 else 0
    })
if __name__ == '__main__':
    app.run(debug=True)
