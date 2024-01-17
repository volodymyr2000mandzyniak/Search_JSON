# Search_Json

Search_json є простим Ruby on Rails веб-застосунком, який дозволяє вам шукати дані в заздалегідь завантаженому наборі даних.

## Встановлення

1. Клонуйте репозиторій: `git clone https://github.com/volodymyr2000mandzyniak/Search_JSON.git
2. Перейдіть у каталог проекту: `cd Search_JSON
3. Встановіть геми та залежності: `bundle install`
4. Запустіть міграції бази даних: `rails db:migrate`
5. Запустіть сервер: `rails server`

У цій роботі ми не використовуємо Active Record, так як у нас відсутня база даних. Усі дані ми зберігаємо та читаємо з файлу JSON.

## Використання

1. Перейдіть за посиланням [http://localhost:3000](http://localhost:3000) у своєму веб-браузері.
2. На головній сторінці ви побачите поле "Search" для введення пошукових даних.
![image](https://github.com/volodymyr2000mandzyniak/Search_JSON/assets/99285760/8ead181b-03d9-4350-a85d-5c014b4dfe41)

3. Після введеня пошукових даних, як результат ми бачимо кількість знайдених елементів та все, що до них належить.
![image](https://github.com/volodymyr2000mandzyniak/Search_JSON/assets/99285760/5760367a-40eb-4e77-b9d7-a1d8aedb39e6)
