/*
'===============================================================================
'  Company: IASD
'  Autor: Ingrid Soto Dimas
'  Date: 2013-09-04
'  **** Generated by MyGeneration Version # (1.3.0.3) ****
'===============================================================================
*/

using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_GenerarNC : EntityBaseClass
    {
        private string strClasifEnc;
        private int intEjercicio;
        private int intMes;
        private string strFolioFiscal;
        private string strConcepto;
        private int intTM;
        private DateTime datFecha;
        private DateTime datFechaAlta;
        private decimal dblTotal;
        private string strNC;
        private string strUsuario;
        private string strMaquina;
        private int intFolioOC;
        private string strFactura;

        public string StrClasifEnc { get => strClasifEnc; set => strClasifEnc = value; }
        public int IntEjercicio { get => intEjercicio; set => intEjercicio = value; }
        public int IntMes { get => intMes; set => intMes = value; }
        public string StrFolioFiscal { get => strFolioFiscal; set => strFolioFiscal = value; }
        public string StrConcepto { get => strConcepto; set => strConcepto = value; }
        public int IntTM { get => intTM; set => intTM = value; }
        public DateTime DatFecha { get => datFecha; set => datFecha = value; }
        public DateTime DatFechaAlta { get => datFechaAlta; set => datFechaAlta = value; }
        public int IntFolioOC { get => intFolioOC; set => intFolioOC = value; }
        public string StrFactura { get => strFactura; set => strFactura = value; }
        public string StrNC { get => strNC; set => strNC = value; }
    }
}