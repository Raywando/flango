from django.db import models
from django.dispatch import receiver
from django.db.models.signals import post_save

class ChatRoom(models.Model):
    room_id = models.CharField(max_length=255, unique=True)

class ChatMessage(models.Model):
    room = models.ForeignKey(ChatRoom, related_name='messages', on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

# Notify other user about the message
@receiver(post_save, sender=ChatMessage)
def new_entry_handler(sender, **kwargs):
    if kwargs.get('created', False):
        print(f"New entry created: {kwargs}")