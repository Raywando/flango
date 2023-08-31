from django.shortcuts import render
from django.http import JsonResponse
import hashlib
import json
from .models import CustomUser

def login(request):
    if request.method == "POST":
        data = json.loads(request.body.decode('utf-8'))
        username = data.get('username')
        password = data.get('password')

        response = CustomUser.verify_password(username, password)
        if type(response) == bool:
            return JsonResponse({'success': response})
        else:
            return JsonResponse({'success': False, 'message': str(response)})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request'})

def register(request):
    if request.method == "POST":
        data = json.loads(request.body.decode('utf-8'))
        username = data.get('username')
        email = data.get('email')
        password = data.get('password')
        print(email)
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        
        try:
            user = CustomUser.objects.create(username=username, email=email, password=hashed_password)
            return JsonResponse({'success': True, 'message': 'User registered successfully'})
        except Exception as e:
            return JsonResponse({'success': False, 'message': str(e)})

        return JsonResponse({'success': False, 'message': 'Invalid request'})
    else:
        return JsonResponse({'success': False, 'message': 'Invalid request'})