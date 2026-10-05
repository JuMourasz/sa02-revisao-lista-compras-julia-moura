// ===================================================================
// ATIVIDADE DE REVISÃO - SA02
// Lista de Compras
// ===================================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      debugShowCheckedModeBanner: false,
      home: const TelaLista(),
    );
  }
}

// ===================================================================
// TODO 1: Classe/modelo Item
// ===================================================================
class Item {
  String nome;
  int quantidade;
  bool comprado;

  Item({
    required this.nome,
    required this.quantidade,
    this.comprado = false,
  });
}

// ===================================================================
// Tela principal (lista)
// ===================================================================
class TelaLista extends StatefulWidget {
  const TelaLista({super.key});

  @override
  State<TelaLista> createState() => _TelaListaState();
}

class _TelaListaState extends State<TelaLista> {
  // TODO 2: Lista que guarda os itens
  final List<Item> _itens = [];

  // Contador de itens comprados
  int get _comprados => _itens.where((i) => i.comprado).length;

  // TODO 3: Abrir tela de adicionar e receber um Item de volta
  Future<void> abrirTelaAdicionar() async {
    final Item? novoItem = await Navigator.push<Item>(
      context,
      MaterialPageRoute(builder: (context) => const TelaAdicionarItem()),
    );

    if (novoItem != null) {
      setState(() {
        _itens.add(novoItem);
      });

      // SnackBar de confirmação
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${novoItem.nome} adicionado à lista')),
      );
    }
  }

  // TODO 4: Remover item da lista
  void removerItem(int indice) {
    final removido = _itens[indice];

    setState(() {
      _itens.removeAt(indice);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${removido.nome} removido da lista')),
    );
  }

  // Alternar estado "comprado"
  void alternarComprado(int indice, bool? valor) {
    setState(() {
      _itens[indice].comprado = valor ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        // TODO 5: Contador "X de Y comprados"
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$_comprados de ${_itens.length} comprados',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),

      // TODO 6: Lista de itens com ListView.builder + Card
      body: _itens.isEmpty
          ? const Center(
              child: Text(
                'Nenhum item na lista.\nToque em + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _itens.length,
              itemBuilder: (context, indice) {
                final item = _itens[indice];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.comprado,
                      onChanged: (valor) => alternarComprado(indice, valor),
                    ),
                    title: Text(
                      item.nome,
                      style: TextStyle(
                        decoration: item.comprado
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: item.comprado ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text('x${item.quantidade}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removerItem(indice),
                    ),
                  ),
                );
              },
            ),

      // TODO 7: FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: abrirTelaAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ===================================================================
// Tela de cadastro de novo item
// ===================================================================
class TelaAdicionarItem extends StatefulWidget {
  const TelaAdicionarItem({super.key});

  @override
  State<TelaAdicionarItem> createState() => _TelaAdicionarItemState();
}

class _TelaAdicionarItemState extends State<TelaAdicionarItem> {
  // TODO 8: Controllers
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  // TODO 9: Função salvar()
  void salvar() {
    final nome = _nomeController.text.trim();
    final quantidadeTexto = _quantidadeController.text.trim();

    // Validação do nome
    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o nome do item!')),
      );
      return;
    }

    // Converte quantidade (padrão 1 se vazio ou inválido)
    final quantidade = int.tryParse(quantidadeTexto) ?? 1;

    final novoItem = Item(
      nome: nome,
      quantidade: quantidade > 0 ? quantidade : 1,
    );

    Navigator.pop(context, novoItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO 10: TextField do nome
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do item',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // TODO 11: TextField da quantidade
            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // TODO 12: ElevatedButton "Salvar"
            ElevatedButton(
              onPressed: salvar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}