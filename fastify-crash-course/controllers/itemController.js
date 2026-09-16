const {v4:uuidv4} = require('uuid')
let items = require('../Items');

const getItems = (req, reply) => {
    reply.send(items)
}

const getItem = (req, reply) => {
    const { id } = req.params

    const replyItem = items.find(item => item.id == id)

    reply.send(replyItem)
}

const addItem = (req, reply) => {
    const {name} = req.body
    const {price} = req.body

    const item = {
        id: uuidv4(),
        name,
        price
    }    

    items = [...items, item]

    reply.code(201).send(item);
}

module.exports = {
    getItems, 
    getItem,
    addItem
}