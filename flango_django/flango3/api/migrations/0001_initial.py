# Generated by Django 3.2.12 on 2023-08-30 20:24

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CustomUser',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('username', models.CharField(max_length=255, unique=True)),
                ('email', models.CharField(max_length=255)),
                ('picture', models.CharField(max_length=255)),
                ('password', models.CharField(max_length=255)),
                ('is_anonymous', models.BooleanField(default=True)),
                ('is_authenticated', models.BooleanField(default=False)),
            ],
        ),
    ]
