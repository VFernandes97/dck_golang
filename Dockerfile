#Utilizada a imagem base abaixo e colocado um "apelido(AS)" para pode referenciar no próximo FROM.
FROM golang:1.20.5-bullseye AS builder
#Alteração para o diretório /app
WORKDIR /app
#Copiando a aplicação para dentro do repositório principal.
COPY app.go .
#Executado os comandos principais para construir a aplicação.
RUN go mod init main && \
    CGO_ENABLED=0 go build 
#Setado o parâmetro acima para construir o binário sem uma dependência externa.
#Abaixo seria o uso do Multistaging, está sendo utilizada a imagem base scratch(não contém nada) para diminuir o tamanho da imagem gerada no build
FROM scratch
EXPOSE 80
#No parâmetro abaixo podemos ver a referência ao primeiro FROM e está sendo feito a cópia dos arquivos gerados no build
COPY --from=builder /app/main /go/main
#Executando a aplicação
CMD ["/go/main"]