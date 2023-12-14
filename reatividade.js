const projeto = {
    id: 1,
    descricao: 'ALura Tracker 3.0'
}

const proxy = new Proxy(projeto, {
    get(objetoOriginal,chave, receptor) {
        return Reflect.get(objetoOriginal,chave, receptor)

    },
    set(objetoOriginal,chave,valor) {
        objetoOriginal[chave] = valor
        console.log('alterado')
        console.log(chave)
    }
})

console.log(projeto.descricao)