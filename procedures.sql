
USE Pizzaria;

DELIMITER $$

DROP PROCEDURE IF EXISTS pedidoDeUmItem $$

CREATE PROCEDURE pedidoDeUmItem(IN cli_id INT, IN piz_id INT, IN qtd INT)
BEGIN
    DECLARE v_preco DECIMAL(8,2);
    DECLARE v_total DECIMAL(8,2);
    DECLARE v_pedido_id INT;

    SELECT valor INTO v_preco FROM Pizzas WHERE pizza_id = piz_id;


    SET v_total = v_preco * qtd;

    INSERT INTO Pedidos (cliente_id, data, hora, valor) 
    VALUES (cli_id, CURDATE(), CURTIME(), v_total);


    SET v_pedido_id = LAST_INSERT_ID();


    INSERT INTO Itens_Pedido (pedido_id, pizza_id, quantidade, valor) 
    VALUES (v_pedido_id, piz_id, qtd, v_preco);
END $$

DELIMITER ;

INSERT INTO Clientes (nome, logradouro, numero, bairro) VALUES
('Thamires de Campos Luz', 'Rua Exemplo', 100, 'Centro'),
('Everton Jose de Souza', 'Rua Exemplo', 200, 'Centro'),
('Silvia Roberta de Jesus Garcia', 'Rua Exemplo', 300, 'Centro');

CALL pedidoDeUmItem(
    (SELECT Cliente_id FROM Clientes WHERE nome = 'Thamires de Campos Luz' LIMIT 1),
    (SELECT pizza_id FROM Pizzas WHERE nome = 'Vienense' LIMIT 1),
    1
);

CALL pedidoDeUmItem(
    (SELECT Cliente_id FROM Clientes WHERE nome = 'Everton Jose de Souza' LIMIT 1),
    (SELECT pizza_id FROM Pizzas WHERE nome = 'Toscana' LIMIT 1),
    2
);
CALL pedidoDeUmItem(
    (SELECT Cliente_id FROM Clientes WHERE nome = 'Silvia Roberta de Jesus Garcia' LIMIT 1),
    (SELECT pizza_id FROM Pizzas WHERE nome = 'Canadense' LIMIT 1),
    1
);

CALL pedidoDeUmItem(
    (SELECT Cliente_id FROM Clientes WHERE nome = 'Silvia Roberta de Jesus Garcia' LIMIT 1),
    (SELECT pizza_id FROM Pizzas WHERE nome LIKE 'Cubana%' LIMIT 1),
    2
);
