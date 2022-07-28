import json
import urllib3
import psycopg2

conn = psycopg2.connect(database="decagon", user="postgres", password="prociple", host="localhost", port="5432")
cur = conn.cursor()
http = urllib3.PoolManager()


def get_countries(_url):
    try:
        response = http.request('GET', _url)
        data = json.loads(response.data.decode('utf-8'))
        count = len(data)

        for i, y in data.items():

            code = i
            name = y['name']
            native = y['native']
            phone = str(y['phone'])
            continent = y['continent']
            capital = y['capital']
            currency = y['currency']
            language = y['languages']

            cur.execute("""
            INSERT INTO public.countries
            VALUES (%s, %s, %s, %s, %s, %s, %s); 
            """, (code, name, native, str(phone).strip('[]'), continent, capital, str(currency).strip('['']')))
            conn.commit()

            # Additionally Loop for language.
            for lang in language:  # ['ps', 'uz', 'tk']

                cur.execute("""
                                INSERT INTO public.countries_languages
                                VALUES (%s, %s); 
                                """, (code, lang))
                conn.commit()

        cur.close()
        print('Success! {} countries were saved.'.format(count))
    except Exception as err:
        print('Oops!, An error occurred: ' + str(err))
        conn.rollback()


def get_languages(_url):
    try:
        response = http.request('GET', _url)
        data = json.loads(response.data.decode('utf-8'))
        count = len(data)

        for i, y in data.items():
            code = i
            name = y['name']
            native = y['native']

            cur.execute("""
            INSERT INTO public.languages
            VALUES (%s, %s, %s); 
            """, (code, name, native))
            conn.commit()

        # cur.close()
        print('Success! A total of {} languages were saved.'.format(count))
    except Exception as err:
        print('Oops!, An error occurred." : ' + str(err))
        conn.rollback()


def get_continents(_url):
    try:
        response = http.request('GET', _url)
        data = json.loads(response.data.decode('utf-8'))
        count = len(data)

        for i, y in data.items():
            code = i
            name = y

            cur.execute("""
            INSERT INTO public.continents
            VALUES (%s, %s); 
            """, (code, name))
            conn.commit()

        # cur.close()
        print('Success! {} continents were saved.'.format(count))
    except Exception as err:
        print('Oops!, an error occurred." : ' + str(err))
        conn.rollback()


if __name__ == "__main__":
    url = "https://raw.githubusercontent.com/annexare/Countries/master/data/continents.json"
    get_continents(url)

    url = "https://raw.githubusercontent.com/annexare/Countries/master/data/languages.json"
    get_languages(url)

    url = "https://raw.githubusercontent.com/annexare/Countries/master/data/countries.json"
    get_countries(url)
