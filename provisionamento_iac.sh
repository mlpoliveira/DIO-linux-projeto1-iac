#!/bin/bash
# Script de provisionamento de infraestrutura por código
# Autor: Maria de Lourdes Oliveira

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
