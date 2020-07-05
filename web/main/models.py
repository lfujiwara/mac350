from django.db import models


class Pessoa(models.Model):
    id = models.AutoField(primary_key=True, db_column='id')
    cpf = models.CharField(unique=True, max_length=11)
    nome = models.CharField(max_length=255)
    area_de_pesquisa = models.CharField(max_length=255, blank=True, null=True)
    instituicao = models.CharField(max_length=255, blank=True, null=True)
    data_de_nascimento = models.DateField(blank=True, null=True)
    endereco = models.CharField(max_length=255, blank=True, null=True)
    login = models.CharField(unique=True, max_length=255, blank=True, null=True)
    senha = models.CharField(max_length=255, blank=True, null=True)
    id_tutor = models.ForeignKey('self', models.DO_NOTHING, db_column='id_tutor', blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'pessoa'

    def __str__(self):
        return f'{self.nome} ({self.cpf})'


class Perfil(models.Model):
    id_perfil = models.AutoField(primary_key=True)
    codigo = models.CharField(unique=True, max_length=255)
    tipo = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'perfil'
        verbose_name_plural = 'Perfis'


class Possui(models.Model):
    id_usuario = models.ForeignKey(Pessoa, models.DO_NOTHING, db_column='id_usuario')
    id_perfil = models.ForeignKey(Perfil, models.DO_NOTHING, db_column='id_perfil')

    class Meta:
        managed = True
        db_table = 'possui'
        unique_together = (('id_usuario', 'id_perfil'),)
        verbose_name_plural = 'Posses (usuário-perfil)'
        verbose_name = 'Posse (usuário-perfil)'


class Servico(models.Model):
    id_servico = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=255)
    classe = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'servico'
        unique_together = (('nome', 'classe'),)
        verbose_name = 'serviço'


class Pertence(models.Model):
    id_servico = models.ForeignKey('Servico', models.DO_NOTHING, db_column='id_servico')
    id_perfil = models.ForeignKey(Perfil, models.DO_NOTHING, db_column='id_perfil')

    class Meta:
        managed = True
        db_table = 'pertence'
        unique_together = (('id_servico', 'id_perfil'),)
        verbose_name_plural = 'posses (perfil-serviço)'
        verbose_name = 'posse (perfil-serviço)'


class Tutelamento(models.Model):
    id_usuario_tutelado = models.ForeignKey(Pessoa, models.DO_NOTHING, db_column='id_usuario_tutelado', related_name="tutelado")
    id_tutor = models.ForeignKey(Pessoa, models.DO_NOTHING, db_column='id_tutor', related_name="tutor")
    id_servico = models.ForeignKey(Servico, models.DO_NOTHING, db_column='id_servico')
    id_perfil = models.ForeignKey(Perfil, models.DO_NOTHING, db_column='id_perfil')
    data_de_inicio = models.DateField()
    data_de_termino = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'tutelamento'
        unique_together = (('id_usuario_tutelado', 'id_tutor', 'id_servico', 'id_perfil'),)


class Exame(models.Model):
    id_exame = models.AutoField(primary_key=True)
    tipo = models.CharField(max_length=255)
    virus = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'exame'
        unique_together = (('tipo', 'virus'),)


class Gerencia(models.Model):
    id_servico = models.ForeignKey('Servico', models.DO_NOTHING, db_column='id_servico')
    id_exame = models.ForeignKey(Exame, models.DO_NOTHING, db_column='id_exame')

    class Meta:
        managed = True
        db_table = 'gerencia'
        unique_together = (('id_servico', 'id_exame'),)
        verbose_name_plural = 'gerenciamentos (serviço-exame)'
        verbose_name = 'gerenciamento (serviço-exame)'


class Realiza(models.Model):
    id_paciente = models.ForeignKey(Pessoa, models.DO_NOTHING, db_column='id_paciente')
    id_exame = models.ForeignKey(Exame, models.DO_NOTHING, db_column='id_exame')
    codigo_amostra = models.CharField(max_length=255, blank=True, null=True)
    data_de_realizacao = models.DateTimeField(blank=True, null=True)
    data_de_solicitacao = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'realiza'
        unique_together = (('id_paciente', 'id_exame', 'data_de_realizacao'),)
        verbose_name_plural = 'realizações'


class Amostra(models.Model):
    id_paciente = models.ForeignKey('Pessoa', models.DO_NOTHING, db_column='id_paciente')
    id_exame = models.ForeignKey('Exame', models.DO_NOTHING, db_column='id_exame')
    codigo_amostra = models.CharField(max_length=255)
    metodo_de_coleta = models.CharField(max_length=255)
    material = models.CharField(max_length=255)

    class Meta:
        managed = True
        db_table = 'amostra'
        unique_together = (('id_paciente', 'id_exame', 'codigo_amostra'),)


class RegistroDeUso(models.Model):
    id_registro_de_uso = models.AutoField(primary_key=True)
    id_usuario = models.ForeignKey(Pessoa, models.DO_NOTHING, db_column='id_usuario')
    id_perfil = models.ForeignKey(Perfil, models.DO_NOTHING, db_column='id_perfil')
    id_servico = models.ForeignKey('Servico', models.DO_NOTHING, db_column='id_servico')
    data_de_uso = models.DateTimeField()

    class Meta:
        managed = True
        db_table = 'registro_de_uso'
        verbose_name_plural = 'registros de uso'
