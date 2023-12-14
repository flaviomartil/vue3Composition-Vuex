<template>
    <Formulario @aoSalvarTarefa="salvarTarefa"/>
    <div class="lista">
        <Box v-if="semTarefas">
            Você não está muito produtivo hoje <span class="has-text-weight-bold">:(</span>
        </Box>
      <Modal :mostrar="tarefaSelecionada != null">
        <template v-slot:cabecalho>
          <p class="modal-card-title">Editando uma tarefa</p>
          <button class="delete" @click="fecharModal"  aria-label="close"></button>
        </template>
        <template v-slot:corpo>
          <div class="field">
            <label for="descricao" class="label"> Descrição </label>
            <input
                type="text"
                class="input"
                v-model="tarefaSelecionada.descricao"
                id="descricao"
            />
          </div>
        </template>
        <template v-slot:rodape>
          <button class="button is-success" @click="alterarTarefa">Salvar alterações</button>
          <button @click="fecharModal" class="button">Cancelar</button>
        </template>
      </Modal>
      <div class="field">
        <p class="control has-icons-left">
          <input class="input" type="text" placeholder="Digite para filtrar" v-model="filtro" >
          <span class="icon is-small is-left">
      <i class="fas fa-search"></i>
    </span>
        </p>
      </div>
        <Tarefa v-for="(tarefa, index) in tarefas" :tarefa="tarefa" :key="index" @aoTarefaClicada="selecionarTarefa"/>
    </div>
</template>

<script lang="ts">
import { computed, defineComponent, ref, watchEffect } from "vue";
import Formulario from "../components/Formulario.vue";
import Tarefa from "../components/Tarefa.vue";
import Modal from "../components/Modal.vue";
import Box from "../components/Box.vue";
import ITarefa from "../interfaces/ITarefa";
import { useStore } from "@/store";
import {
  OBTER_TAREFAS,
  CADASTRAR_TAREFA,
  OBTER_PROJETOS,
  ALTERAR_TAREFA,
} from "@/store/tipo-acoes";

export default defineComponent({
  name: "App",
  components: {
    Formulario,
    Tarefa,
    Box,
    Modal
  },
  data() {
    return {
      tarefaSelecionada: null as ITarefa | null,
    };
  },

  methods: {
    salvarTarefa(tarefa: ITarefa): void {
      this.store.dispatch(CADASTRAR_TAREFA, tarefa);
    },
    alterarTarefa() {
      this.store
          .dispatch(ALTERAR_TAREFA, this.tarefaSelecionada)
          .then(() => this.fecharModal());
    },
    selecionarTarefa(tarefa: ITarefa) {
      this.tarefaSelecionada = tarefa;
    },
    fecharModal() {
      this.tarefaSelecionada = null;
    },
  },
  computed: {},

  setup() {
    const store = useStore();
    const filtro = ref("");
    // Use onMounted para garantir que as ações foram concluídas antes de acessar os dados
    store.dispatch("OBTER_TAREFAS");
    store.dispatch("OBTER_PROJETOS");

    watchEffect(() => {
      store.dispatch(OBTER_TAREFAS, filtro.value);
    });

    // Use computed para obter tarefas e garantir reatividade
    const tarefas = computed(() =>
        store.state.tarefa.tarefas.filter(
            (t) => !filtro.value || t.descricao.includes(filtro.value)
        )
    );

    // Use computed para calcular semTarefas
    const semTarefas = computed(() => store.state.tarefa.tarefas.length === 0);

    return {
      tarefas,
      semTarefas,
      store,
      filtro,
    };
  },
});
</script>
