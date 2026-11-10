workspace "TONK — Plataforma de Gestão Comercial" "Modelo arquitetural proposto para o fluxo de aprovação e integração de pedidos comerciais." {

    !identifiers hierarchical

    model {
        representante = person "Representante" "Registra pedidos, consulta condições comerciais e acompanha o andamento."
        aprovador = person "Aprovador comercial" "Analisa pedidos que ultrapassam as alçadas configuradas."

        tonk = softwareSystem "Plataforma TONK" "Plataforma de gestão comercial, representação e logística industrial." {
            portal = container "Portal Web / PWA" "Interface para representantes, gestores e equipes internas." "React, TypeScript, Vite, Tailwind CSS"
            api = container "API Comercial" "Expõe operações de pedidos, regras comerciais, autorização e workflow." "Node.js, TypeScript, REST/HTTPS"
            worker = container "Worker de Integração" "Processa eventos persistidos na Outbox e realiza retentativas controladas." "Node.js, TypeScript"
            db = container "Banco de Dados" "Armazena pedidos, versões comerciais, usuários, permissões, tabelas e eventos Outbox." "PostgreSQL (Supabase)"
            storage = container "Armazenamento de documentos" "Armazena documentos comerciais gerados e arquivos associados." "Supabase Storage"
        }

        erp = softwareSystem "ERP da TONK (Protheus)" "Sistema corporativo externo. Contrato, endpoints e mecanismo de integração dependem de validação técnica com a equipe responsável."
        logistica = softwareSystem "Operação logística" "Equipe ou sistema responsável por receber pedidos liberados para separação e expedição."

        representante -> tonk.portal "Utiliza" "HTTPS"
        aprovador -> tonk.portal "Analisa e decide" "HTTPS"
        tonk.portal -> tonk.api "Solicita operações comerciais" "HTTPS / REST + JSON"
        tonk.api -> tonk.db "Lê e grava dados transacionais" "PostgreSQL / TLS"
        tonk.api -> tonk.storage "Armazena e consulta documentos" "HTTPS"
        tonk.worker -> tonk.db "Consome eventos pendentes e registra resultado" "PostgreSQL / TLS"
        tonk.worker -> erp "Transmite pedido aprovado; contrato a definir" "Conector via HTTPS (proposta)"
        erp -> logistica "Disponibiliza pedido integrado para operação logística" "Fluxo operacional a confirmar"
    }

    views {
        systemContext tonk "Contexto" {
            include *
            autolayout lr
        }

        container tonk "Containers" {
            include *
            autolayout lr
        }

        styles {
            element "Person" {
                shape person
                background #084C61
                color #FFFFFF
            }
            element "Software System" {
                background #12304A
                color #FFFFFF
            }
            element "Container" {
                background #087E8B
                color #FFFFFF
            }
        }
    }
}
