
### Criação de infraestrutura de usuários, grupos e diretórios no Linux

Esse script automatiza a criação de grupos de usuários, criação de usuários associados a esses grupos, criação de diretórios e configuração de permissões adequadas para cada diretório.

### Funcionalidade do Script

O script realiza as seguintes ações:

1.  Criação dos diretórios `/publico`, `/adm`, `/ven`, `/sec`.
    
2.  Criação de 3 grupos: `GRP_ADM`, `GRP_VEN`, `GRP_SEC`.
    
3.  Criação de 9 usuários, associando-os aos grupos corretos.
    
4.  Configuração de permissões para os diretórios:
    
    -   `/publico`: permissões 777 (todos podem ler, escrever e executar).
        
    -   `/adm`, `/ven`, `/sec`: permissões 770 (somente membros dos grupos podem acessar).
  
### Exemplo de Código
```bash

#!/bin/bash
# Script de provisionamento de infraestrutura por código
# Autor: xxxx

# Verificar execução como root
if [[ $EUID -ne 0 ]]; then
   echo "Execute como root!" >&2
   exit 1
fi

# Remover estruturas anteriores
echo "Limpando ambiente..."
rm -rf /publico /adm /ven /sec
for usuario in carlos maria joao debora sebastiana roberto josefina amanda rogerio; do
    userdel -r $usuario 2>/dev/null
done
groupdel GRP_ADM GRP_VEN GRP_SEC 2>/dev/null

# Criar grupos
groupadd GRP_ADM && echo "Grupo GRP_ADM criado"
groupadd GRP_VEN && echo "Grupo GRP_VEN criado"
groupadd GRP_SEC && echo "Grupo GRP_SEC criado"

# Criar diretórios
mkdir -p /publico /adm /ven /sec
chmod 777 /publico
chmod 770 /adm /ven /sec

# Configurar permissões
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

# Criar usuários e associar grupos
criar_usuario() {
    useradd -m -s /bin/bash -p $(openssl passwd -6 Senha123) $1
    [ $? -eq 0 ] && echo "Usuário $1 criado" || echo "Erro ao criar $1"
}

for usuario in carlos maria joao; do
    criar_usuario $usuario
    usermod -aG GRP_ADM $usuario
done

for usuario in debora sebastiana roberto; do
    criar_usuario $usuario
    usermod -aG GRP_VEN $usuario
done

for usuario in josefina amanda rogerio; do
    criar_usuario $usuario
    usermod -aG GRP_SEC $usuario
done

echo "Provisionamento concluído!"
```


### Passos para Executar o Script

1.  Salve o conteúdo acima em um arquivo chamado `infraestrutura.sh`.
    
2.  Dê permissão de execução ao script:
```bash
chmod +x infraestrutura.sh
```

3. Execute o script como root:

```bash
sudo ./infraestrutura.sh
```

### Passos para Subir no GitHub

1. Crie um repositório no GitHub.
2. No diretório onde está o script, execute:

```bash
git init
git add infraestrutura.sh
git commit -m "Adiciona script para criação de usuários, grupos e diretórios"
git push origin main
```

### Considerações de Segurança

- A senha Senha123 é apenas um exemplo e não deve ser utilizada em produção. É importante modificar as senhas para valores seguros.

- O script deve ser executado com privilégios de root, portanto, tenha cuidado ao rodá-lo.

