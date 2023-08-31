import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import async_to_sync
import uuid
from . import utils as db

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        print(f'scope: {self.scope}')
        self.room_id = self.scope['url_route']['kwargs']['room_id']
        self.chat_room_object = (await db.create_or_get_room(self.room_id))[0]
        await self.channel_layer.group_add(self.room_id, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_id, self.channel_name)

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']
        
        await db.add_message(self.chat_room_object, message)
        await self.channel_layer.group_send(
            self.room_id,
            {
                'type': 'chat_message',
                'channel_name': self.channel_name,
                'message': message,
            }
        )

    async def chat_message(self, event):
        print(f'original channel_name: {self.channel_name}')
        print(f'event channel_name: {event["channel_name"]}')

        if self.channel_name != event['channel_name']: # dont send to this connection because its the sender
            print('not the sender')
            message = event['message']
            await self.send(text_data=json.dumps({
                'type': 'chat_message',
                'message': message,
            }))
        else:
            print('same sender')
