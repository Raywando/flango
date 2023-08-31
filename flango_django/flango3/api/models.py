from django.db import models
import hashlib

class CustomUser(models.Model):
    username = models.CharField(max_length=255, unique=True)
    email = models.CharField(max_length=255)
    picture = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    is_anonymous = models.BooleanField(default=True)
    is_authenticated = models.BooleanField(default=False)

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = []

    @classmethod
    def create_user(cls, username, email, picture, password):
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        user = cls(username=username, email=email, picture=picture, password=hashed_password)
        user.save()
        return user

    def verify_password(username, password):
        try:
            user = CustomUser.objects.get(username=username)
            if (not user): return False
            hashed_input_password = hashlib.sha256(password.encode()).hexdigest()
            return user.password == hashed_input_password
        except Exception as e:
            return e