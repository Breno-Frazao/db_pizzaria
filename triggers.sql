
USE Pizzaria;

tem
DELIMITER $$

DROP TRIGGER IF EXISTS trg_atualiza_valor_pedido $$

CREATE TRIGGER trg_atualiza_valor_pedido
AFTER INSERT ON Itens_Pedido
FOR EACH ROW
BEGIN

    UPDATE Pedidos 
    SET valor = IFNULL(valor, 0) + (NEW.quantidade * NEW.valor)
    WHERE pedido_id = NEW.pedido_id;
END $$

DELIMITER ;

INSERT INTO Pedidos (cliente_id, data, hora, valor) 
VALUES ((SELECT Cliente_id FROM Clientes WHERE nome = 'Claudiane Mendes Trigueiro Silva' LIMIT 1), CURDATE(), CURTIME(), 0);

SET @ped1 = LAST_INSERT_ID();

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor) VALUES 
(@ped1, (SELECT pizza_id FROM Pizzas WHERE nome = 'Aliche' LIMIT 1), 2, (SELECT valor FROM Pizzas WHERE nome = 'Aliche' LIMIT 1)),
(@ped1, (SELECT pizza_id FROM Pizzas WHERE nome = 'Firense' LIMIT 1), 1, (SELECT valor FROM Pizzas WHERE nome = 'Firense' LIMIT 1));

INSERT INTO Pedidos (cliente_id, data, hora, valor) 
VALUES ((SELECT Cliente_id FROM Clientes WHERE nome = 'Diogo Matos da Silva' LIMIT 1), CURDATE(), CURTIME(), 0);

SET @ped2 = LAST_INSERT_ID();

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor) VALUES 
(@ped2, (SELECT pizza_id FROM Pizzas WHERE nome = 'Toscana' LIMIT 1), 2, (SELECT valor FROM Pizzas WHERE nome = 'Toscana' LIMIT 1)),
(@ped2, (SELECT pizza_id FROM Pizzas WHERE nome = 'Grega' LIMIT 1), 1, (SELECT valor FROM Pizzas WHERE nome = 'Grega' LIMIT 1));

INSERT INTO Pedidos (cliente_id, data, hora, valor) 
VALUES ((SELECT Cliente_id FROM Clientes WHERE nome = 'Eder Almeida Batista de Oliveira' LIMIT 1), CURDATE(), CURTIME(), 0);

SET @ped3 = LAST_INSERT_ID();

INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor) VALUES 
(@ped3, (SELECT pizza_id FROM Pizzas WHERE nome = 'Canadense' LIMIT 1), 1, (SELECT valor FROM Pizzas WHERE nome = 'Canadense' LIMIT 1)),
(@ped3, (SELECT pizza_id FROM Pizzas WHERE nome = 'Margherita' LIMIT 1), 2, (SELECT valor FROM Pizzas WHERE nome = 'Margherita' LIMIT 1));

SELECT 
    p.pedido_id,
    c.nome AS cliente,
    p.data,
    p.hora,
    p.valor AS valor_calculado_trigger,
    SUM(ip.quantidade * ip.valor) AS soma_real_itens
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.Cliente_id
INNER JOIN Itens_Pedido ip ON p.pedido_id = ip.pedido_id
GROUP BY p.pedido_id, c.nome, p.data, p.hora, p.valor;
