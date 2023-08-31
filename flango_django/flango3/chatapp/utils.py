from channels.db import database_sync_to_async
import uuid

@database_sync_to_async
def create_or_get_room(new_room_id):
    from .models import ChatRoom
    # new_room_id = str(uuid.uuid4())
    print(f'adding the room {new_room_id}')
    return ChatRoom.objects.get_or_create(room_id=new_room_id)

@database_sync_to_async
def add_message(room, message):
    from .models import ChatMessage,ChatRoom
    return ChatMessage.objects.create(room=room, content=message)