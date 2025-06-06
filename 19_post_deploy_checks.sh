#!/bin/bash

echo "🔍 MENÚ DE VERIFICACIÓN DE LA PLATAFORMA PCD"
select option in "Comprobar pods" "Comprobar servicios" "Comprobar ingress" "Ver logs de un pod" "Salir"; do
  case $option in
    "Comprobar pods")
      kubectl get pods -A
      ;;
    "Comprobar servicios")
      kubectl get svc -A
      ;;
    "Comprobar ingress")
      kubectl get ingress -A
      ;;
    "Ver logs de un pod")
      echo "Introduce el namespace:"
      read ns
      echo "Introduce el nombre del pod:"
      read pod
      kubectl logs -n $ns $pod
      ;;
    "Salir")
      break
      ;;
    *)
      echo "Opción no válida"
      ;;
  esac
done
