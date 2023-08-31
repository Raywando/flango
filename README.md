## flango_django setup:
 - `cd flango_django`
 - `pip install requirements.txt`
 - `python3 manage.py migrate`
 - `daphne flango3.asgi:application -b 0.0.0.0 -p 7000`

## flango_flutter setup:
 - `cd flango_flutter`
 - `flutter run -d [EMULATOR_1]`
 - `flutter run -d [EMULATOR_2]`
