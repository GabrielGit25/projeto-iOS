# AltStore Test — app iOS sem conta de desenvolvedor

App SwiftUI minimalista (interface branca simples) para testar a distribuição
via **AltStore Classic**, sem precisar de conta de desenvolvedor da Apple
($99/ano).

## Como funciona

1. Você seu código para um repositório público no GitHub.
2. O **GitHub Actions** (macOS na nuvem, grátis em repositório público) compila
   o app com XcodeGen + `xcodebuild` e gera um `.ipa` **sem assinatura**.
3. Você publica o `.ipa` numa **GitHub Release** e hospeda o `source.json`.
4. Usuários adicionam sua fonte no AltStore e instalam. O **AltStore assina o
   app com o Apple ID do próprio usuário** — por isso não precisa do seu
   desenvolvedor.

## Estrutura

```
App/                         # Código SwiftUI (Swift padrão, sem dependências)
project.yml                  # Especificação XcodeGen (gera o .xcodeproj na nuvem)
.github/workflows/build.yml  # Workflow que compila e gera o .ipa
source.json                  # Fonte do AltStore (configurar com suas URLs)
assets/app-icon.png          # Ícone exibido na listagem do AltStore
```

## Passo a passo

### 1. Subir o código

Crie um repositório **público** no GitHub (ex.: `AltStoreTest`) e envie esta
pasta:

```powershell
git init
git add .
git commit -m "App de teste para AltStore"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/AltStoreTest.git
git push -u origin main
```

> [!IMPORTANT]
> O repositório precisa ser **público** para usar o runner macOS do GitHub
> Actions sem custo. Em repositório privado, o build também funciona, mas
> consome créditos (runner macOS vale 10x).

### 2. Gerar o .ipa

Duas opções:

- **Automática:** crie uma tag no GitHub. `git tag v1.0.0` + `git push --tags`.
- **Manual:** na aba **Actions** do repositório, rode o workflow **Build IPA**
  (botão *Run workflow*).

O workflow compila e publica o arquivo `AltStoreTest.ipa`.

### 3. Baixar o .ipa

Se usou a tag, o `.ipa` vira um anexo da **GitHub Release** `v1.0.0`, e a URL
de download fica:

```
https://github.com/SEU-USUARIO/AltStoreTest/releases/download/v1.0.0/AltStoreTest.ipa
```

### 4. Configurar o source.json

Edite o `source.json` trocando os marcadores:

| Marcar | Troque por |
| --- | --- |
| `SEU-USUARIO` | Seu usuário no GitHub |
| `SEU-REPO` | Nome do seu repositório |
| `com.exemplo.altstoretest` | Um bundle ID único (ex.: `com.seunome.altstoretest`) — **precisa ser igual** ao do `project.yml` e nunca ter sido usado por outro app |
| `Seu Nome` | Seu nome/apelido de desenvolvedor |
| `v1.0.0` | A tag da release (se mudar o app, suba a versão aqui e no `project.yml`) |

O mesmo bundle ID deve ser atualizado em `project.yml`:

```yaml
PRODUCT_BUNDLE_IDENTIFIER: com.exemplo.altstoretest   # << trocar aqui também
```

Não use o ID de outro app (ex.: o `com.facebook.katana` daria conflito).

### 5. Hospedar o source.json

O arquivo precisa estar num HTTPS público. O jeito mais simples (grátis) é
deixar no próprio repositório e usar a URL *raw*:

```
https://raw.githubusercontent.com/SEU-USUARIO/AltStoreTest/main/source.json
```

> Se quiser uma URL mais limpa, publique o `source.json` num **GitHub Pages**
> ou em qualquer host estático (Netlify, Vercel, Cloudflare Pages).

### 6. Instalar no AltStore

No iPhone (com AltStore e AltServer já configurados):

1. Abra `altstore://source?url=...` com a URL do seu `source.json` (adicione a
   fonte em **Sources**).
2. A fonte aparece em *Browse*; toque em **AltStore Test** e confirme a
   instalação.
3. O AltStore pede o **Apple ID** do *seu* iPhone (gratuito) para assinar.

> [!TIP]
> Links agradáveis para os usuários: monte uma página com o botão
> `altstore://source?url=http...` ou `altstore://install?url=https://.../app.ipa`.

## Importante: renovação de 7 dias

Com **Apple ID gratuito**, os apps instalados expiram em **7 dias** e precisam
ser re-assinados. O AltStore renova automaticamente quando o iPhone e o PC com
AltServer estão na **mesma rede Wi-Fi**, ou via **AltStore Team** (pago).

Com Apple ID pago ($99/ano), os certificados valem 1 ano — mas aí você já
poderia usar outros fluxos oficiais.

## Limitações e dicas

- O `.ipa` é **sem assinatura**; o AltStore o re-assina na instalação.
- Não use *capabilities* que exigem conta paga (push, iCloud, etc.) no projeto.
- `source.json` sem permissões/entitlements: como o app não usa nada, a lista
  de permissões fica vazia. Se adicionar recursos (câmera, fotos...), declare
  em `appPermissions`; o AltStore recusa instalar apps cujas permissões não
  batem com o `.ipa`.
- Teste em um dispositivo de verdade: o build é para `arm64` (iPhones/iPads).
- Se mudar o `PRODUCT_BUNDLE_IDENTIFIER`, desinstale a versão antiga antes.

## Troubleshooting

- **Build falha em `xcodegen`:** rode de novo; se persistir, veja os logs do
  workflow na aba Actions.
- **AltStore não instala:** confira se a URL do `.ipa` responde HTTPS e se o
  `bundleIdentifier`/`version` batem com o `.ipa`.
- **App expirou:** conecte o iPhone ao Wi-Fi do PC com AltServer e abra o
  AltStore, ou use o modo de renovação.