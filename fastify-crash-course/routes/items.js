const items = require('../Items');

//Definizione degli item
const Item = {
  type: 'object',
  properties: {
    // id: {type: 'string'},
    name: {type: 'string'},
    price: {type: 'number'}
  }
}


//Definizione delle options oggetti
const getItemsRoutesOptions = {
    schema: {
        response: {
            200: {
                type: 'array',
                items: Item
            }
        }
    }
}

const getItemRouteOptions = {
    schema: {
        response: {
            200: Item
        }
    }
}

function itemRoutes(fastify, options, done) {
    
    fastify.get('/items', getItemsRoutesOptions, (req, reply) => {
        reply.send(items)
    })

    fastify.get('/items/:id', getItemRouteOptions, (req, reply) => {
        const { id } = req.params

        const item = items.find(item => item.id = id)

        reply.send(item)
    })
    done();
}

module.exports = itemRoutes