from flask import Flask, session, redirect, flash, request, render_template
from model import User, Reservation, connect_to_db, db
from datetime import datetime, timedelta
import os

app = Flask(__name__)
app.secret_key = os.environ['FLASK_SECRET_KEY']

@app.route('/')
def home():
    if 'user_id' in session:
        return redirect('/search')
    else:
        return redirect('/login')

@app.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        user = User.query.filter(User.email==request.form.get('email')).first()
        if user is None:
            flash('Invalid user name! Please try again.')
            return render_template('login.html')
        else:
            session['user_id'] = user.user_id
            session['user_email'] = user.email
            flash(f'Welcome, {user.email}!')
            return redirect('/search')
    elif request.method == 'GET':
        if 'user_id' in session:
            return redirect('/search')
        return render_template('login.html')

@app.route('/search')
def search():
    if 'user_id' not in session:
        flash('You must log in to continue!')
        return redirect('/login')
    
    return render_template('search.html') 

@app.route('/view_appointments')
def view_appointments():
    if 'user_id' not in session:
        flash('You must log in to continue!')
        return redirect('/login')

    date = request.args.get('date')
    start_time = request.args.get('start_time')
    end_time = request.args.get('end_time')
    try:
        start_date = datetime.strptime(f'{date} {start_time}', '%Y-%m-%d %H:%M')
        end_date = datetime.strptime(f'{date} {end_time}', '%Y-%m-%d %H:%M')
    except:
        flash('Error: invalid search parameters!')
        return redirect('/search')
    print(start_date, end_date)

    # Check if this user already has an appointment that day
    user = User.query.get(session['user_id'])
    for reservation in user.reservations:
        if reservation.time.date() == start_date.date():
            flash('Sorry, you are already signed up for an appointment on that day!')
            return redirect('/search')

    # Get all the reservations already booked on that day
    existent_reservations = [r.time for r in 
        Reservation.query.filter((Reservation.time >= start_date) & (Reservation.time < end_date)).all()]

    valid_reservations = []
    cur = start_date
    while cur < end_date:
        if cur not in existent_reservations:
            valid_reservations.append(cur)
        cur = cur + timedelta(minutes=30)

    if len(valid_reservations) == 0:
        flash('Sorry, no reservations are available during those times. Choose another interval!')
        return redirect('/search')

    return render_template('choose_appointment.html', reservations=valid_reservations)

@app.route('/book_appointment', methods=['POST'])
def book_appointment():
    if 'user_id' not in session:
        flash('You must log in to continue!')
        return redirect('/login')

    user = User.query.get(session['user_id'])
    
    try:
        date = request.form.get('date')   

        # check that the date is available
        if Reservation.query.filter_by(time=date).first():
            flash('Error: Appointment already exists!')
            return redirect('/search')
        
        new_reservation = Reservation(time=date, user=user)
        db.session.add(new_reservation)
        db.session.commit()
        flash("Appointment created!")
        return redirect("/search")

    except:
        flash("Sorry, we couldn't fulfill that request! Please try again.")
        return redirect('/search')
    

@app.route('/my_reservations')
def my_reservations():
    if 'user_id' not in session:
        flash('You must log in to continue!')
        return redirect('/login')

    user = User.query.get(session['user_id'])
    return render_template('my_reservations.html', reservations=user.reservations)
    

if __name__ == '__main__':
    connect_to_db(app)
    app.run(host='0.0.0.0', port=5000, debug=True)