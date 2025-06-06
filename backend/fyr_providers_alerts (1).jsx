import React, { useEffect, useState } from "react";
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow
} from "@/components/ui/table";
import {
  Input
} from "@/components/ui/input";
import {
  Button
} from "@/components/ui/button";
import {
  AlertTriangle
} from "lucide-react";
import axios from "axios";

interface Documento {
  proveedor: string;
  tipo: string;
  estado?: string;
  fecha_vencimiento?: string;
  origen?: "manual" | "automatico";
}

export const metadata = {
  name: "ProveedorAlertView",
  description: "Módulo de FYR para visualizar, subir y validar documentación de proveedores.",
  icon: "alert-triangle",
};

export default function ProveedorAlertView() {
  const [documentos, setDocumentos] = useState<Documento[]>([]);
  const [filtroTipo, setFiltroTipo] = useState("");
  const [filtroCertificado, setFiltroCertificado] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [csv, setCsv] = useState<File | null>(null);
  const [checklistVisible, setChecklistVisible] = useState(false);
  const [alertaTiempoReal, setAlertaTiempoReal] = useState<string | null>(null);

  useEffect(() => {
    axios.get("http://document-control:8091/documentos").then((res) => {
      setDocumentos(res.data);
    });

    const ws = new WebSocket("ws://alerts-engine:8090/ws/fyr-client");
    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      if (data?.type === "document") {
        setAlertaTiempoReal(data.message);
        setTimeout(() => setAlertaTiempoReal(null), 6000);
      }
    };
    return () => ws.close();
  }, []);

  const filtrados = documentos.filter((doc) => {
    return (
      doc.tipo.toLowerCase().includes(filtroTipo.toLowerCase()) &&
      (filtroCertificado === "" || (doc.origen || "manual") === filtroCertificado)
    );
  });

  const handleFileUpload = async () => {
    if (!file) return;
    const formData = new FormData();
    formData.append("file", file);
    await axios.post("http://document-control:8091/documentos", formData);
    setMessage("Documento subido y validado correctamente.");
    setTimeout(() => setMessage(null), 3000);
    window.location.reload();
  };

  const handleCsvUpload = async () => {
    if (!csv) return;
    const formData = new FormData();
    formData.append("file", csv);
    await axios.post("http://document-control:8091/import-csv", formData);
    setMessage("Configuración cargada desde CSV.");
    setTimeout(() => setMessage(null), 3000);
    window.location.reload();
  };

  return (
    <div className="space-y-4">
      {alertaTiempoReal && (
        <div className="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 shadow">
          <p className="font-semibold">⚠️ Alerta:</p>
          <p>{alertaTiempoReal}</p>
        </div>
      )}
      <div className="flex flex-wrap gap-4 items-center">
        <Input
          placeholder="Filtrar por tipo de documento"
          value={filtroTipo}
          onChange={(e) => setFiltroTipo(e.target.value)}
          className="w-64"
        />
        <select
          value={filtroCertificado}
          onChange={(e) => setFiltroCertificado(e.target.value)}
          className="border rounded p-2"
        >
          <option value="">Todos</option>
          <option value="manual">Manual</option>
          <option value="automatico">Automático</option>
        </select>
        <input type="file" onChange={(e) => setFile(e.target.files?.[0] || null)} />
        <Button onClick={handleFileUpload} disabled={!file}>Subir Documento</Button>
        <input type="file" onChange={(e) => setCsv(e.target.files?.[0] || null)} />
        <Button onClick={handleCsvUpload} disabled={!csv}>Importar CSV</Button>
        <Button variant="outline" onClick={() => setChecklistVisible(!checklistVisible)}>
          Validación Manual
        </Button>
      </div>
      {message && <div className="text-green-600 font-semibold">{message}</div>}
      {checklistVisible && (
        <div className="border p-4 rounded bg-gray-50">
          <h4 className="text-md font-bold mb-2">Checklist de Validación</h4>
          <ul className="list-disc ml-6 space-y-1 text-sm">
            <li>¿Contiene sello y firma digital?</li>
            <li>¿Está dentro de la fecha de validez?</li>
            <li>¿Cumple normativa del tipo de documento?</li>
            <li>¿Corresponde al proveedor correcto?</li>
          </ul>
        </div>
      )}
      <div className="overflow-auto">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>Proveedor</TableHead>
              <TableHead>Tipo Documento</TableHead>
              <TableHead>Estado</TableHead>
              <TableHead>Fecha Vencimiento</TableHead>
              <TableHead>Certificado</TableHead>
              <TableHead>Alerta</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filtrados.map((doc, index) => (
              <TableRow key={index}>
                <TableCell>{doc.proveedor}</TableCell>
                <TableCell>{doc.tipo}</TableCell>
                <TableCell>{doc.estado || "ok"}</TableCell>
                <TableCell>{doc.fecha_vencimiento || "-"}</TableCell>
                <TableCell>{doc.origen || "manual"}</TableCell>
                <TableCell>
                  {(doc.estado === "invalido" || doc.estado === "vencido") && (
                    <AlertTriangle className="text-red-500" size={18} />
                  )}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}
