const items = require('../Items');

const getItems = (req, reply) => {
    reply.send(items)
}

const getItem = (req, reply) => {
    const { id } = req.params

    const replyItem = items.find(item => item.id == id)

    reply.send(replyItem)
}

const addItem = (req, reply) => {
    const itemOBJ = req.params

    
}

module.exports = {
    getItems, 
    getItem,
}