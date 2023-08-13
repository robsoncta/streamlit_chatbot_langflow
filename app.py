import streamlit as st
import requests

st.title("Chat com Boteliza")

url = "https://cosrobs-boteliza.hf.space/api/v1/process/38f81618-1f6d-4410-8574-2f02b6aef4e7"
headers = {
    'Content-Type': 'application/json'
}
tweaks = {
    "ChatOpenAI-opmjC": {},
    "LLMChain-1P9Dz": {},
    "PromptTemplate-6x9b5": {},
    "ConversationBufferMemory-bX4FO": {}
}

user_input = st.text_input("Digite sua mensagem:")

if user_input:
    data = {
        "inputs": {"text": user_input},
        "tweaks": tweaks
    }

    response = requests.post(url, headers=headers, json=data)
    
    if response.status_code == 200:
        bot_response = response.json().get("generated_text", "")
        st.write(f"Bot: {bot_response}")
    else:
        st.write("Desculpe, ocorreu um erro ao se comunicar com o bot.")

st.write("Aguarde a resposta do bot após digitar sua mensagem.")
