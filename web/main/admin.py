from django.contrib import admin
from .models import Pessoa, Perfil, Possui, Servico, Pertence, \
    Tutelamento, Exame, Gerencia, Realiza, Amostra, RegistroDeUso
# Register your models here.

admin.site.register(Pessoa)
admin.site.register(Perfil)
admin.site.register(Possui)
admin.site.register(Servico)
admin.site.register(Pertence)
admin.site.register(Tutelamento)
admin.site.register(Exame)
admin.site.register(Gerencia)
admin.site.register(Realiza)
admin.site.register(Amostra)
admin.site.register(RegistroDeUso)
