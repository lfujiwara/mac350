const generateUsers = require('./generators/generateUsers')
const fs = require('fs')
const knex = require('knex')({
  client: 'pg',
  connection: {
    host: 'localhost',
    port: '5432',
    user: 'mac350_2020',
    password: 'mac350_2020',
    database: 'mac350_2020',
  },
})
const faker = require('faker')
const gcpf = require('cpf')

const USERS_QTY = 100
const TUTORED_USERS_QTY = 25
const PATIENTS_QTY = 500

const main = async () => {
  const generated = generateUsers(USERS_QTY)

  const users = generated.users

  const usersFilename = `${__dirname}/dump/insert_users.sql`

  const insertions = [
    'SET search_path TO exam_tracker;',
    "SELECT inserir_servico('Inserir exame', 'inserção');",
    "SELECT inserir_servico('Visualizar qualquer exame', 'visualização');",
    "SELECT inserir_servico('Alterar qualquer exame', 'alteração');",
    "SELECT inserir_servico('Remover qualquer exame', 'remoção');",
    "SELECT inserir_perfil('DEFAULT', 'Acesso padrão');",
    "SELECT inserir_perfil('GUEST', 'Acesso convidado');",
    "SELECT inserir_perfil('ROOT', 'Superusuário');",
  ]

  const postInsertions = []

  const services = {
    create:
      "SELECT id_servico FROM servico WHERE servico.nome = 'Inserir exame' LIMIT 1",
    read:
      "SELECT id_servico FROM servico WHERE servico.nome = 'Visualizar qualquer exame' LIMIT 1",
    update:
      "SELECT id_servico FROM servico WHERE servico.nome = 'Alterar qualquer exame' LIMIT 1",
    delete:
      "SELECT id_servico FROM servico WHERE servico.nome = 'Remover qualquer exame' LIMIT 1",
  }

  const profiles = {
    default:
      "SELECT id_perfil FROM perfil WHERE perfil.tipo = 'Acesso padrão' LIMIT 1",
    guest:
      "SELECT id_perfil FROM perfil WHERE perfil.tipo = 'Acesso convidado' LIMIT 1",
    root:
      "SELECT id_perfil FROM perfil WHERE perfil.tipo = 'Superusuário' LIMIT 1",
  }

  Object.values(services).forEach(v =>
    insertions.push(
      `SELECT adicionar_servico_a_perfil((${v}), (${profiles.root}));`
    )
  )

  Array.from([services.read, services.create]).forEach(v =>
    insertions.push(
      `SELECT adicionar_servico_a_perfil((${v}), (${profiles.default}));`
    )
  )

  insertions.push(
    `SELECT adicionar_servico_a_perfil((${services.read}), (${profiles.guest}));`
  )

  const selectByCpf = cpf =>
    `SELECT id FROM pessoa WHERE pessoa.cpf = '${cpf}' LIMIT 1`
  const selectProfileByCpf = cpf =>
    `SELECT id_perfil FROM possui WHERE possui.id_usuario = (${selectByCpf(
      cpf
    )}) LIMIT 1`

  users.forEach(user => {
    const params = [
      user.cpf,
      user.nome,
      user.area_de_pesquisa,
      user.instituicao,
      user.data_de_nascimento,
      user.login,
      user.senha,
    ]

    const query = knex.raw(
      `SELECT inserir_usuario(${params
        .map(param => `\'${param.toString().replace("'", "''")}\'`)
        .join(', ')})`
    )
    insertions.push(`${query};`)
    postInsertions.push(
      `SELECT adicionar_perfil_a_usuario((${faker.random.arrayElement(
        Object.values([profiles.default, profiles.root])
      )}), (${selectByCpf(user.cpf)}));`
    )
  })

  insertions.push('COMMIT;', ...postInsertions)

  const tutors = users.map(user => user.cpf)

  const generated_tutored = generateUsers(TUTORED_USERS_QTY, {
    cpf: new Set(...tutors),
    login: new Set(...users.map(x => x.login)),
  })

  const tutoredUsers = generated_tutored.users.map(user => ({
    ...user,
    cpf_tutor: tutors[Math.floor(Math.random() * tutors.length)],
  }))

  tutoredUsers.forEach(user => {
    const interval = 1000 * 60 * 60 * 24 * 180
    const startDate = faker.date
      .between(new Date(Date.now() - interval), new Date(Date.now() + interval))
      .toISOString()
    const endDate = faker.date
      .between(
        new Date(new Date(startDate).getTime() + interval / 180),
        new Date(new Date(startDate).getTime() + interval)
      )
      .toISOString()

    const params = [
      user.cpf,
      user.nome,
      user.area_de_pesquisa,
      user.instituicao,
      user.data_de_nascimento,
      user.login,
      user.senha,
      user.cpf_tutor,
    ]

    const query = `SELECT inserir_usuario_tutorcpf(${[
      ...params.map(param => `\'${param.toString().replace(/'/, "''")}\'`),
      `(${faker.random.arrayElement(Object.values(services))})`,
      `(${faker.random.arrayElement(
        Object.values([selectProfileByCpf(user.cpf_tutor), profiles.guest])
      )})`,
      `'${startDate}'`,
      `'${endDate}'`,
    ].join(', ')})`

    insertions.push(`${query};`)
  })

  for (let i = 0; i < PATIENTS_QTY; i++) {
    const params = [
      gcpf.generate(false),
      `${faker.name.firstName()} ${faker.name.lastName()}`,
      faker.address.streetAddress(true).slice(0, 256),
      faker.date.between('1960-01-01', '1999-12-31').toISOString(),
    ]

    const query = `SELECT inserir_paciente(${params
      .map(param => `\'${param.toString().replace("'", "''")}\'`)
      .join(', ')})`

    insertions.push(`${query};`)
  }

  fs.writeFileSync(usersFilename, insertions.join('\n'))
}

main()
