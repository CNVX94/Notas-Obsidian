# CLAUDE.md

Lee y sigue **@AGENTS.md** — identidad del agente, reglas del vault y restricción HARD de credenciales (sección 6).

## MCP de Obsidian — auto-setup (primera sesión)

La config del servidor ya viene en `.mcp.json` (Claude Code la carga sola al abrir el repo): lanza `uvx mcp-obsidian`, que habla con el plugin Local REST API en `https://127.0.0.1:27124`. Verifica en orden y corrige lo que falte:

1. **uv/uvx instalados** (requisito para lanzar el servidor):
   ```powershell
   uv --version; uvx --version
   ```
   Si faltan, instala (confirma con el usuario primero):
   ```powershell
   winget install --id=astral-sh.uv -e
   ```
   (alternativa: `irm https://astral.sh/uv/install.ps1 | iex`). Tras instalar, avisa que debe reiniciar Claude Code para que `uvx` esté en el PATH del proceso.

2. **API key definida:**
   ```powershell
   [Environment]::GetEnvironmentVariable('OBSIDIAN_API_KEY','User')
   ```
   Si está vacía, pide al usuario la key (Obsidian → Settings → Local REST API → Copy API Key) y guárdala:
   ```powershell
   [Environment]::SetEnvironmentVariable('OBSIDIAN_API_KEY','<key>','User')
   ```
   Avisa que debe reiniciar Claude Code para que el proceso herede la variable. **NUNCA escribas la key en archivos del repo ni en `Memoria/`** (AGENTS.md sección 6).

3. **Plugin responde:**
   ```powershell
   curl.exe -k https://127.0.0.1:27124/
   ```
   Si falla, pide al usuario: abrir Obsidian y habilitar el plugin **Local REST API** (Community plugins).

4. **Si el MCP sigue sin responder**, usa Read/Grep/Edit directos sobre los archivos del vault. El trabajo nunca se bloquea por el MCP.
