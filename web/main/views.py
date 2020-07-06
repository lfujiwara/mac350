from django.http import HttpResponse
from django.template import loader
from django.db import connection
from django.shortcuts import render


def parse_result(result):
    def remove_commas(s):
        ESCAPE_CHARS = ["'", '"']
        switch = False
        indexes = []
        for i in range(len(s)):
            if s[i] == ',' and not switch:
                indexes.append(i)
            if s[i] in ESCAPE_CHARS:
                switch = not switch
        units = []
        for i in range(len(indexes)):
            start = 0 if i == 0 else (indexes[i-1] + 1)
            end = indexes[i]
            if (start < end):
                units.append(s[start:end])
            else:
                units.append('')
        if len(indexes) > 0:
            units.append(s[indexes[-1]+1:])
        return units

    r = list(map(lambda x: x[0][1:-1], result))
    r = list(map(remove_commas, r))

    return r


def index(request):
    template = loader.get_template('index.html')
    return HttpResponse(template.render())


def query1(request):
    with connection.cursor() as c:
        c.execute("SELECT exam_tracker.get_exames_realizados()")
        data = c.fetchall()

    result = parse_result(data)
    table_data = list(map(lambda x: {
        'Nome': str(x[0]).replace('"', '', 999),
        'Tipo': x[1],
        'Vírus': x[2],
        'Data de solicitação': str(x[3]).replace('"', '', 999),
        'Data de realização': str(x[4]).replace('"', '', 999)
    }, result))

    ctx = {
        'headers': ['Nome', 'Tipo', 'Vírus',
                    'Data de solicitação', 'Data de realização'],
        'data': list(map(lambda x: x.values(), table_data))
    }

    return render(request, 'query.html', ctx)


def query2(request):
    with connection.cursor() as c:
        c.execute("SELECT exam_tracker.get_top_fast()")
        data = c.fetchall()

    result = parse_result(data)
    table_data = list(map(lambda x: {
        'Código de amostra': str(x[0]).replace('"', '', 999),
        'Tipo': x[1],
        'Vírus': x[2],
        'Data de realização': str(x[3]).replace('"', '', 999),
        'Data de solicitação': str(x[4]).replace('"', '', 999),
        'Tempo': str(x[5])
    }, result))

    ctx = {
        'headers': ['Código de amostra', 'Tipo', 'Vírus',
                    'Data de realização', 'Data de solicitação', 'Intervalo (solicitação até realização)'],
        'data': list(map(lambda x: x.values(), table_data))
    }

    return render(request, 'query.html', ctx)


def query3(request):
    with connection.cursor() as c:
        c.execute("SELECT exam_tracker.seleciona_servico_usuario()")
        data = c.fetchall()

    result = parse_result(data)
    table_data = list(map(lambda x: {
        'Nome': str(x[0]).replace('"', '', 999),
        'Classe': str(x[1]).replace('"', '', 999).capitalize(),
        'Nome de usuário': str(x[2]).replace('"', '', 999),
        'Área de pesquisa': str(x[3] if len(x) >= 5 else '').replace('"', '', 999),
        'Instituição': str(x[4] if len(x) >= 5 else '').replace('"', '', 999),
    }, result))

    ctx = {
        'headers': ['Nome', 'Classe', 'Nome de usuário',
                    'Área de pesquisa', 'Instituição'],
        'data': list(map(lambda x: x.values(), table_data))
    }

    return render(request, 'query.html', ctx)


def query4(request):
    with connection.cursor() as c:
        c.execute("SELECT exam_tracker.seleciona_servico_usuario_tutelado()")
        data = c.fetchall()

    result = parse_result(data)
    table_data = list(map(lambda x: {
        'Nome': str(x[0]).replace('"', '', 999),
        'Classe': str(x[1]).replace('"', '', 999).capitalize(),
        'Nome de usuário': str(x[2]).replace('"', '', 999),
        'Instituição': str(x[3]).replace('"', '', 999),
        'Área de pesquisa': str(x[4] if len(x) >= 5 else '').replace('"', '', 999),
    }, result))

    ctx = {
        'headers': ['Nome', 'Classe', 'Nome de usuário',
                    'Área de pesquisa', 'Instituição'],
        'data': list(map(lambda x: x.values(), table_data))
    }

    return render(request, 'query.html', ctx)


def query5(request):
    with connection.cursor() as c:
        c.execute("SELECT exam_tracker.seleciona_servico_utilizados()")
        data = c.fetchall()

    result = parse_result(data)
    table_data = list(map(lambda x: {
        'Nome': str(x[0]).replace('"', '', 999),
        'Código': str(x[1]).replace('"', '', 999).capitalize(),
        'Quantidade': str(x[2]).replace('"', '', 999),
    }, result))

    ctx = {
        'headers': ['Nome', 'Código', 'Quantidade'],
        'data': list(map(lambda x: x.values(), table_data))
    }

    return render(request, 'query.html', ctx)
