from flask import Blueprint, render_template, request, flash, redirect, url_for
from .models import User
from werkzeug.security import generate_password_hash, check_password_hash
from . import db
from flask_login import login_user, login_required, logout_user, current_user


auth = Blueprint('auth', __name__)

@auth.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form.get("email")
        password = request.form.get("password")

        user = User.query.filter_by(email=email).first()
        if user:
            if check_password_hash(user.password, password):
                flash("Loggin success", category="success")
                login_user(user, remember=True)
                return render_template('home.html', user=current_user)
            else:
                flash("Incorrect password, try again", category="error")

        else:
            flash("Email does not exsit", category="error")

    return render_template("login.html", user=current_user)

@auth.route("/logout")
@login_required
def logout():
    logout_user()
    return redirect(url_for("auth.login"))

@auth.route('/about')
def about():
    return render_template('about.html', user=current_user)

@auth.route('/')
def home():
    return render_template('home.html', user=current_user)

    # Todo
    # Create an about page a
    # Create a homepage for people that are not logged in


@auth.route("/sign-up", methods=["GET", "POST"])
def sign_up():
    if request.method == "POST":
        email = request.form.get("email")
        first_name = request.form.get("firstName")
        password1 = request.form.get("password1")
        password2 = request.form.get("password2")

        user = User.query.filter_by(email=email).first()
        if user:
            flash("Email already exists", category="error")

        if len(email) < 4:
            flash("Email must be greater than 3 charaters", category="error")
            
        elif len(first_name) < 2:
            flash("First name must be greater than 1 charaters", category="error")
            
        elif password1 != password2:
            flash("Passwords dont match", category="error")
            
        elif len(password1) < 7:
            flash("Password too short, must be atleast 7 charaters", category="error")
            
        else:
            new_user = User(email=email, first_name=first_name, password=generate_password_hash(password1))
            db.session.add(new_user)
            db.session.commit()
            #login_user(user)
            flash("Account created", category="success")

            return render_template('home.html', user=current_user)

            # add user to db


    return render_template("sign_up.html", user = current_user)
