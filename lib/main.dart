import 'package:flutter/material.dart';

void main() {
  runApp(AppCrud());
}

class Produto {
  String nome;
  String categoria;
  double preco;

  Produto({
    required this.nome,
    required this.categoria,
    required this.preco,
  });
}

class AppCrud extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.deepOrangeAccent,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Adiciona a imagem do logo
                Image.asset(
                  'img/logo.png',
                  height: 244, // Ajuste conforme necessário
                  width: 275, // Ajuste conforme necessário
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuário: Giovanna',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black)),
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha: rocha123'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Verificar credenciais
                if (_usernameController.text == 'Giovanna' &&
                    _passwordController.text == 'rocha123') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProdutoListPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login efetuado com sucesso')),
                  );
                } else {
                  // Exibir mensagem de erro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Credenciais inválidas')),
                  );
                }
              },
              child: Text('Login'),
            ),
            Text('Giovanna Rocha - TechSquad'),
          ],
        ),
      ),
    );
  }
}

class ProdutoListPage extends StatefulWidget {
  @override
  _ProdutoListPageState createState() => _ProdutoListPageState();
}

class _ProdutoListPageState extends State<ProdutoListPage> {
  // Lista de produtos (simulando um banco de dados)
  List<Produto> produto = [
    Produto(nome: 'Produto 1', categoria: 'categoria 1', preco: 5.00),
    Produto(nome: 'Produto 2', categoria: 'categoria 2', preco: 3.50),
    Produto(nome: 'Produto 3', categoria: 'categoria 3', preco: 18.00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de compras'),
      ),
      body: ListView.builder(
        itemCount: produto.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(produto[index].nome),
            subtitle: Text(produto[index].categoria +
                ' - ' +
                'preço: ' +
                produto[index].preco.toString()),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Excluir produto
                produto.removeAt(index);
                // Atualizar a interface
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Produto removido')),
                );
                // Atualizar a lista de produtos
                setState(() {});
              },
            ),
            onTap: () async {
              // Editar o produto
              Produto updatedProduto = await showDialog(
                context: context,
                builder: (context) {
                  TextEditingController _nomeController =
                      TextEditingController(text: produto[index].nome);
                  TextEditingController _categoriaController =
                      TextEditingController(text: produto[index].categoria);
                  TextEditingController _precoController =
                      TextEditingController(
                          text: produto[index].preco.toString());

                  return AlertDialog(
                    title: Text('Editar Produto'),
                    content: Column(
                      children: [
                        TextField(
                          controller: _nomeController,
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                        TextField(
                          controller: _categoriaController,
                          decoration: InputDecoration(labelText: 'Categoria'),
                        ),
                        TextField(
                          controller: _precoController,
                          decoration: InputDecoration(labelText: 'Preço'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Validar e salvar as alterações
                          if (_nomeController.text.isNotEmpty &&
                              _categoriaController.text.isNotEmpty &&
                              _precoController.text.isNotEmpty) {
                            Navigator.pop(
                              context,
                              Produto(
                                  nome: _nomeController.text.trim(),
                                  categoria: _categoriaController.text.trim(),
                                  preco: double.parse(
                                      _precoController.text.trim())),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Edição efetuada com sucesso')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Preencha todos os campos corretamente')),
                            );
                          }
                        },
                        child: Text('Salvar'),
                      ),
                    ],
                  );
                },
              );

              if (updatedProduto != null) {
                // Atualizar o produto na lista
                produto[index] = updatedProduto;
                // Atualizar a interface
                setState(() {});
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Adicionar novo produto
          Produto newProduto = await showDialog(
            context: context,
            builder: (context) {
              TextEditingController _nomeController = TextEditingController();
              TextEditingController _categoriaController =
                  TextEditingController();
              TextEditingController _precoController = TextEditingController();

              // Adicionar novo produto
              return AlertDialog(
                title: Text('Novo Produto'),
                content: Column(
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                    ),
                    TextField(
                      controller: _categoriaController,
                      decoration: InputDecoration(labelText: 'Categoria'),
                    ),
                    TextField(
                      controller: _precoController,
                      decoration: InputDecoration(labelText: 'Preço'),
                    ),
                  ],
                ),

                // Cancelar operação
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),

                  // Validar e adicionar o novo produto
                  TextButton(
                    onPressed: () {
                      if (_nomeController.text.isNotEmpty &&
                          _categoriaController.text.isNotEmpty &&
                          _precoController.text.isNotEmpty) {
                        Navigator.pop(
                          context,
                          Produto(
                              nome: _nomeController.text.trim(),
                              categoria: _categoriaController.text.trim(),
                              preco:
                                  double.parse(_precoController.text.trim())),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Produto adicionado com sucesso')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Preencha todos os campos corretamente')),
                        );
                      }
                    },
                    child: Text('Adicionar'),
                  ),
                ],
              );
            },
          );

          // Verificar espaço a ser alocado para a adição do novo produto
          if (newProduto != null) {
            // Adicionar o novo produto à lista
            produto.add(newProduto);

            // Atualizar a tela
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
