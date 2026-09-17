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

    //items = [...items, item]
    items.push(item)

    reply.code(201).send(item);
}

const deleteItem = (req, reply) => {
    const id = req.params

    //items = [...items, item]
    //items.pop(id)
    //itemstemp = items.indexOf(id)
    //items.splice(itemstemp, 1)

    items = items.filter(item => item.id !== id)

    reply.code(200).send("Item deleted");
}

module.exports = {
    getItems, 
    getItem,
    addItem,
    deleteItem
}