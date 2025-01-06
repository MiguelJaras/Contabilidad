using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using Contabilidad.DataAccess;
using System.Text;
using System.Diagnostics;
using System.Collections.Generic;
using System.Reflection;
using System.Threading;
using System.Xml;
using System.Xml.Linq;
/// <summary>
/// Funciones
/// </summary>
public class UtilFunctions 
{
    public UtilFunctions()
    { 
    }

    public static string makeWebRequest(string host)
    {
        //var request = (HttpWebRequest)WebRequest.Create(new Uri(host));
        WebRequest request = WebRequest.Create(host);

        //var response = (HttpWebResponse)request.GetResponse();

        request.Credentials = CredentialCache.DefaultCredentials;
        // Get the response.
        WebResponse response = request.GetResponse();


        Stream dataStream = response.GetResponseStream();
        StreamReader dataread = new StreamReader(dataStream);
        return dataread.ReadToEnd();
    }


    /// <summary>
    /// ShowAlert
    /// Parametros:       p_Form: pagina contenedora 
    ///             p_StrMensaje:Mensaje que se mostrara
    /// </summary>
    public static void ShowAlert(System.Web.UI.Page p_Form, string p_strMensaje)
    { 
        Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "Alerta", "alert('" + p_strMensaje + "');", true); 
        //p_strMensage = p_strMensage.Replace("'", String.Empty).Replace("\n", " ").Replace("\r", " ");
        //if (!p_Form.IsStartupScriptRegistered("MensageAlerta"))
        //    p_Form.RegisterStartupScript("MensageAlerta", "<SCRIPT language='javascript'>alert('" + p_strMensage + "');</SCRIPT>");
    }

    /// <summary>
    /// setFoco
    /// Parametros: p_Form: pagina contenedora 
    ///             strNextControlFocus:Control que se le dara el foco
    /// </summary>
    public static void setFoco(System.Web.UI.Page p_Form, string strNextControlFocus)
    {
        Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "focus", "document.all('" + strNextControlFocus + "').focus();", true);
    }

    /// <summary>
    /// limpiarPagina
    /// Parametros: p_Form: pagina contenedora  
    /// </summary>
    public static void limpiarPagina(System.Web.UI.Page p_Form)
    {
        if (!p_Form.IsStartupScriptRegistered("limpiarPagina"))
            p_Form.RegisterStartupScript("limpiarPagina", "<SCRIPT language='javascript'>window.location=window.location;</SCRIPT>");
    } 

    /// <summary>
    /// Limpia Controles
    /// Parametros: p_Form: pagina contenedora 
    ///             pStrCampos: Controles a limpiar tipo Anthem  
    /// </summary>
    public static void limpiarCampos(System.Web.UI.Page p_Form, string p_strCampos)
    {
        Int16 intCount;
        string[] arrCampos = (p_strCampos.Split(char.Parse(",")));
        try
        {
            for (intCount = 0; intCount <= arrCampos.Length - 1; intCount++)
            {
                Control ctr = FindControlRecursive(p_Form, arrCampos[intCount].Trim());
                switch (ctr.GetType().ToString())
                {
                    case "Anthem.TextBox": 
                        ((Anthem.TextBox)ctr).Text = string.Empty;
                        ((Anthem.TextBox)ctr).UpdateAfterCallBack = true;
                        break;

                    case "Anthem.DropDownList":
                        if (((Anthem.DropDownList)ctr).Items.Count > 0)
                        {
                            ((Anthem.DropDownList)ctr).SelectedIndex = 0;
                            // ((Anthem.DropDownList)ctr).Enabled = false;
                            ((Anthem.DropDownList)ctr).UpdateAfterCallBack = true;
                        }
                            break;

                        case "Anthem.CheckBox": 
                            ((Anthem.CheckBox)ctr).Checked = false;
                            ((Anthem.CheckBox)ctr).UpdateAfterCallBack = true;
                            break;

                    case "Anthem.DataGrid":
                        ((Anthem.DataGrid)ctr).DataSource = null;
                        ((Anthem.DataGrid)ctr).DataBind();
                        ((Anthem.DataGrid)ctr).UpdateAfterCallBack = true;
                            break;

                    case "Anthem.GridView":
                        ((Anthem.GridView)ctr).DataSource = null;
                        ((Anthem.GridView)ctr).DataBind();
                        ((Anthem.GridView)ctr).UpdateAfterCallBack = true;
                        break;

                    case "Anthem.ListBox":
                        ((Anthem.ListBox)ctr).DataSource = null;
                        ((Anthem.ListBox)ctr).DataBind();
                        ((Anthem.ListBox)ctr).UpdateAfterCallBack = true;
                        break;

                        case "Anthem.HiddenField": 
                            ((Anthem.HiddenField)ctr).Value = "";
                            ((Anthem.HiddenField)ctr).UpdateAfterCallBack = true;
                            break;
                } 
            }
        }
        catch (Exception e)
        {
            ShowAlert(p_Form, e.Message + " Control: " + arrCampos);
            //HttpContext.Current.Response.Write(e.Message + " Control: " + arrCampos /*[intCount]*/);
        }
    }

    /// <summary>
    /// Carga DataSource en un combo de tipo anthem
    /// Parametros: strClassName: Nombre de la clase DAC donde se obtendra del metodo heredado QueryHelpData 
    ///             arr: Arreglo con variables que seran spliteadas en los stored Help
    ///             strDataValueField: Variable que contendra el nombre de la columna del DataTable para asignar el DataValueField en el DataValueField del control
    ///             strDataValueField:Variable que contendra el nombre de la columna del DataTable para asignar el strDataTextField en el DataTextField  del control
    ///             ctrCombo: Combo que se llenara y asignaran los valores del DataTable
    /// </summary>
    public void setFillDataControls(int IntEmpresa,int IntSucursal, string strClassName, string[] arr, int intVersion, string strDataTextField, string strDataValueField, Anthem.DropDownList ctrCombo)
    {
        try
        {
            Type t = System.Web.Compilation.BuildManager.GetType("Contabilidad.DataAccess." + strClassName, true, true);

            Contabilidad.DataAccess.Base objBase = (Contabilidad.DataAccess.Base)Activator.CreateInstance(t);

            using (DataSet ds = objBase.QueryHelpData(IntEmpresa, IntSucursal, arr, intVersion))
            {
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        ctrCombo.DataSource = ds;
                        ctrCombo.DataTextField = strDataTextField;
                        ctrCombo.DataValueField = strDataValueField;
                        ctrCombo.DataBind();
                        ctrCombo.Enabled = true;
                        goto Done;
                    }
                }

                ctrCombo.DataSource = null;
                ctrCombo.DataBind();
                ctrCombo.Enabled = false;

            Done:
                ctrCombo.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
                ctrCombo.SelectedIndex = 0;
                ctrCombo.UpdateAfterCallBack = true;
            }

        }
        catch (System.IO.IOException ex) { }

    }

    /// <summary>
    /// Metodo para llenar controles con un dataset. Se pueden enviar varios tipos de controles, mientras se respete las estructura de los mismos.
    /// </summary>
    /// <param name="p_Form">pagina contenedora</param>
    /// <param name="IntEmpresa">Empresa session</param>
    /// <param name="IntSucursal">Sucursal Session</param>
    /// <param name="strClassName">Nombre de la clase DAC donde se obtendra del metodo heredado QueryHelpData </param>
    /// <param name="arr">Arreglo con variables que seran spliteadas en los stored Help</param>
    /// <param name="intVersion">Numero para obtener query a ejecutar en HelpStored</param>
    /// <param name="strControls">Se debe enviar dependiendo tipo de control 
    /// Caso de TextBox txtNombre,DataName  
    /// Caso de DropDownList ComboName,DataTextField,DataValueField  
    /// Caso de Anthem.DataGrid OR Anthem.RadioButtonList  DataGridName OR RadioButtonListName 
    /// En caso de querer enviar varios campos a llenar se deben splitear con ¬ 
    /// Tantos tipos de controles se necesite siempre manteniendo la estructura de cada control.
    /// </param>
    /// <example>txtNombre,DataName¬txtNombre,DataName¬RadioButtonListName¬DataGridName¬ComboName,DataTextField,DataValueField</example>

    public void setFillDataControls(System.Web.UI.Page p_Form, int IntEmpresa, int IntSucursal, string strClassName, string[] arr, int intVersion, string strControls)
    {
        try
        {
            Type t = System.Web.Compilation.BuildManager.GetType("Contabilidad.DataAccess." + strClassName, true, true);

            Contabilidad.DataAccess.Base objBase = (Contabilidad.DataAccess.Base)Activator.CreateInstance(t);

            using (DataSet ds = objBase.QueryHelpData(IntEmpresa, IntSucursal, arr, intVersion))
            {
                if (ds != null)
                {
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            #region Ds
                            Int16 intCount;
                            string[] arrCampos = (strControls.Split(char.Parse("¬")));
                            foreach (string crtName in arrCampos)
                            {
                                string[] arrNames = crtName.Split(',');
                                Control ctr = FindControlRecursive(p_Form, arrNames[0]);
                                switch (ctr.GetType().ToString())
                                {
                                    case "Anthem.TextBox":
                                        ((Anthem.TextBox)ctr).Text = arrNames.Length > 0 ? ds.Tables[0].Rows[0][arrNames[1]].ToString() : string.Empty;
                                        ((Anthem.TextBox)ctr).UpdateAfterCallBack = true;
                                        break;

                                    case "Anthem.Label":
                                        ((Anthem.Label)ctr).Text = arrNames.Length > 0 ? ds.Tables[0].Rows[0][arrNames[1]].ToString() : string.Empty;
                                        ((Anthem.Label)ctr).UpdateAfterCallBack = true;
                                        break;

                                    case "Anthem.DropDownList":

                                        ((Anthem.DropDownList)ctr).DataSource = ds;
                                        ((Anthem.DropDownList)ctr).DataTextField = arrNames.Length > 1 ? arrNames[1] : string.Empty;//strDataTextField;
                                        ((Anthem.DropDownList)ctr).DataValueField = arrNames.Length > 2 ? arrNames[2] : string.Empty;//strDataValueField;
                                        ((Anthem.DropDownList)ctr).DataBind();

                                        ((Anthem.DropDownList)ctr).Items.Insert(0, new ListItem(arrNames.Length > 3 ? arrNames[3] : "-- Seleccione --", "0"));
                                        ((Anthem.DropDownList)ctr).SelectedIndex = 0;
                                        ((Anthem.DropDownList)ctr).UpdateAfterCallBack = true;

                                        break;

                                    case "Anthem.RadioButtonList":

                                        ((Anthem.RadioButtonList)ctr).DataSource = ds;
                                        ((Anthem.RadioButtonList)ctr).DataBind();
                                        ((Anthem.RadioButtonList)ctr).UpdateAfterCallBack = true;
                                        break;

                                    case "Anthem.CheckBoxList":

                                        ((Anthem.CheckBoxList)ctr).DataSource = ds;
                                        if (arrNames.Length > 3)
                                            ((Anthem.CheckBoxList)ctr).DataBound += new EventHandler(UtilFunctions_DataBound);

                                        ((Anthem.CheckBoxList)ctr).DataTextField = arrNames.Length > 1 ? arrNames[1] : string.Empty;//strDataTextField;
                                        ((Anthem.CheckBoxList)ctr).DataValueField = arrNames.Length > 2 ? arrNames[2] : string.Empty;//strDataValueField;
                                        ((Anthem.CheckBoxList)ctr).DataBind();
                                        ((Anthem.CheckBoxList)ctr).UpdateAfterCallBack = true;
                                        break;

                                    case "Anthem.DataGrid":
                                        ((Anthem.DataGrid)ctr).DataSource = ds;
                                        ((Anthem.DataGrid)ctr).DataBind();
                                        ((Anthem.DataGrid)ctr).UpdateAfterCallBack = true;
                                        break;

                                    case "Anthem.GridView":
                                        ((Anthem.GridView)ctr).DataSource = ds;
                                        ((Anthem.GridView)ctr).DataBind();
                                        ((Anthem.GridView)ctr).UpdateAfterCallBack = true;
                                        break;
                                    case "Anthem.ListBox":

                                        ((Anthem.ListBox)ctr).DataSource = ds;
                                        ((Anthem.ListBox)ctr).DataTextField = arrNames.Length > 1 ? arrNames[1] : string.Empty;//strDataTextField;
                                        ((Anthem.ListBox)ctr).DataValueField = arrNames.Length > 2 ? arrNames[2] : string.Empty;//strDataValueField;
                                        ((Anthem.ListBox)ctr).DataBind();

                                        ((Anthem.ListBox)ctr).Items.Insert(0, new ListItem(arrNames.Length > 3 ? arrNames[3] : "-- Seleccione --", "0"));
                                        ((Anthem.ListBox)ctr).SelectedIndex = 0;

                                        ((Anthem.ListBox)ctr).UpdateAfterCallBack = true;
                                        break;

                                    case "Anthem.HiddenField":
                                        ((Anthem.HiddenField)ctr).Value = "";
                                        ((Anthem.HiddenField)ctr).UpdateAfterCallBack = true;
                                        break;
                                }
                            }

                            #endregion
                        }
                        else
                        {
                            string[] arrCampos = (strControls.Split(char.Parse("¬")));
                            foreach (string crtName in arrCampos)
                            {
                                //string[] arrNames = crtName.Split(',');
                                foreach (string strName in crtName.Split(','))
                                {
                                    limpiarCampos(p_Form, strName);
                                    break;
                                }
                            }
                        }
                    }
                    else
                    {
                        string[] arrCampos = (strControls.Split(char.Parse("¬")));
                        foreach (string crtName in arrCampos)
                        {
                            //string[] arrNames = crtName.Split(',');
                            foreach (string strName in crtName.Split(','))
                            {
                                limpiarCampos(p_Form, strName);
                                continue;
                            }
                        }
                    }

                }
            }

        }
        catch (System.IO.IOException ex) { }

    }

    #region WriteInFile & EventLog
    public static void WriteInFile(string strLinesinFile)
    {
        string strFileName = HttpContext.Current.Server.MapPath("~/Temp/ErrorLog_") + DateTime.Now.Year.ToString("####") + DateTime.Now.Month.ToString("00") + DateTime.Now.Day.ToString("00") + DateTime.Now.Hour.ToString("00") + DateTime.Now.Minute.ToString("00") + DateTime.Now.Second.ToString("00") + ".mno";

        try
        {
            if (createDirectoryIfnotExist(strFileName))
            {
                if (!System.IO.File.Exists(strFileName))
                    using (System.IO.File.Create(strFileName)) ;

                using (System.IO.StreamWriter sw = new System.IO.StreamWriter(strFileName))
                {
                    sw.WriteLine(strLinesinFile);
                    sw.Close();
                }
            }

            //System.IO.File.WriteAllText(strFileName, strLinesinFile);
        }
        catch (System.IO.IOException ex) { }

    }

    public static void WriteInFile(string strFileName, string strMessage, bool Overwrite)
    {
        if (strFileName.Contains(HttpContext.Current.Server.MapPath("~/Temp/")))
            try
            {
                if (createDirectoryIfnotExist(strFileName))
                {
                    if (!System.IO.File.Exists(strFileName))
                        using (System.IO.File.Create(strFileName)) ;

                    using (System.IO.StreamWriter sw = new System.IO.StreamWriter(strFileName, true))
                    {
                        sw.WriteLine(strMessage);
                        sw.Close();
                    }
                }

                //System.IO.File.WriteAllText(strFileName, strLinesinFile);
            }
            catch (System.IO.IOException ex) { }
        else WriteInFile(strMessage);


    }

    public static bool createDirectoryIfnotExist(string fileName)
    {
        try
        {
            string path = getPath(fileName);
            if (path != "")
            {
                if (!System.IO.Directory.Exists(path))
                    System.IO.Directory.CreateDirectory(path);

                return true;
            }
        }
        catch (System.IO.PathTooLongException exPath) { setEventLogMessage("PathTooLongException" + exPath.Message); }
        catch (System.IO.DirectoryNotFoundException exPath) { setEventLogMessage("DirectoryNotFoundException" + exPath.Message); }
        catch (System.IO.IOException exPath) { setEventLogMessage("IOException" + exPath.Message); }

        return false;
    }

    public static string getPath(string fileName)
    {
        try
        {
            System.IO.FileInfo myFile = new System.IO.FileInfo(fileName);
            return myFile.Directory.ToString();
        }
        catch (System.IO.PathTooLongException exPath) { setEventLogMessage("PathTooLongException" + exPath.Message); }
        //catch (System.IO.DirectoryNotFoundException exPath) { setEventLogMessage("DirectoryNotFoundException" + exPath.Message); }
        catch (System.IO.IOException exPath) { setEventLogMessage("IOException" + exPath.Message); }

        return "";
    }

    public static void setEventLogMessage(string strMessage)
    {
        using (EventLog m_EventLog = new EventLog(""))
        {
            m_EventLog.Source = "EXEC Contabilidad";
            m_EventLog.WriteEntry("Error MNO " + DateTime.Now + " " + strMessage);
        }

    }

    #endregion

    void UtilFunctions_DataBound(object sender, EventArgs e)
    {
        foreach (ListItem l in ((Anthem.CheckBoxList)sender).Items)
        {
            if (l.Text.Split(',').Length > 1)
            {
                l.Selected = l.Text.Split(',')[1].ToString() == "0" ? false : true;
                l.Text = l.Text.Split(',')[0].ToString();
            }
        }
    }

    public void TextChangeHelp(System.Web.UI.Page p_Form, string[] arrCampos, int intEmpresa, int intSucursal, string strClassName, string[] arr, int intVersion, string strNextControlFocus)
    { 
            try
            {
                Type t = System.Web.Compilation.BuildManager.GetType("Contabilidad.DataAccess." + strClassName, true, true); 
                Contabilidad.DataAccess.Base objBase = (Contabilidad.DataAccess.Base)Activator.CreateInstance(t);
Clear(p_Form, arrCampos);
                using (DataSet ds = objBase.QueryHelpData(intEmpresa, intSucursal, arr, intVersion))
                {
                if (ds != null)
                {
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {  
                            DataRow row = ds.Tables[0].Rows[0];

                            for (int intCount = 0; intCount <= arrCampos.Length - 1; intCount++)
                            {
                                Control ctr = FindControlRecursive(p_Form, arrCampos[intCount]);
                                if (ctr != null)
                                {
                                    switch (ctr.GetType().ToString())
                                    {
                                        case "Anthem.TextBox":
                                            ((Anthem.TextBox)ctr).Text = row[intCount].ToString();
                                            ((Anthem.TextBox)ctr).UpdateAfterCallBack = true;
                                            break;
                                        case "Anthem.Label":
                                            ((Anthem.Label)ctr).Text = row[intCount].ToString();
                                            ((Anthem.Label)ctr).UpdateAfterCallBack = true;
                                            break;

                                        case "Anthem.DropDownList":
                                            if (((Anthem.DropDownList)ctr).Items.Count > 0)
                                            {
                                                ((Anthem.DropDownList)ctr).SelectedValue = row[intCount].ToString();
                                                ((Anthem.DropDownList)ctr).UpdateAfterCallBack = true;
                                            }
                                            break;

                                        case "Anthem.HiddenField":
                                            ((Anthem.HiddenField)ctr).Value = row[intCount].ToString();
                                            ((Anthem.HiddenField)ctr).UpdateAfterCallBack = true;
                                            break;
                                    }
                                }
                            }

                            if (strNextControlFocus != null)
                                if (strNextControlFocus != "")
                                    Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "focus", "document.all('" + FindControlRecursive(p_Form, strNextControlFocus).ClientID + "').focus();", true);

                            return;
                        }
                        else
                        {
                            //Clear(p_Form, arrCampos);
                            Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "focus", "document.all('" + FindControlRecursive(p_Form, arrCampos[0]).ClientID + "').focus();", true);
                        }
                    }
                     else
                        {
                            //Clear(p_Form, arrCampos);
                        Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "focus", "document.all('" + FindControlRecursive(p_Form, arrCampos[0]).ClientID + "').focus();", true);
                    }
                }
                else
                {
                    //Clear(p_Form, arrCampos);
                    Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "focus", "document.all('" + FindControlRecursive(p_Form, arrCampos[0]).ClientID + "').focus();", true);
                        }    
                } 
                 
            }
            catch (System.IO.IOException ex) { } 
    }

    public void Clear(System.Web.UI.Page p_Form, string[] arrCampos)
    {
        for (int intCount = 0; intCount <= arrCampos.Length - 1; intCount++)
        {
            Control ctr = FindControlRecursive(p_Form, arrCampos[intCount]);
            if (ctr != null)
            {
                switch (ctr.GetType().ToString())
                {
                    case "Anthem.TextBox":

                        ((Anthem.TextBox)ctr).Text = "";
                        ((Anthem.TextBox)ctr).UpdateAfterCallBack = true;

                        break;

                    case "Anthem.Label":
                        ((Anthem.Label)ctr).Text = "";
                        ((Anthem.Label)ctr).UpdateAfterCallBack = true;
                        break;

                    case "Anthem.DropDownList":
                        if (((Anthem.DropDownList)ctr).Items.Count > 0)
                        {
                            ((Anthem.DropDownList)ctr).SelectedIndex = 0;
                            ((Anthem.DropDownList)ctr).UpdateAfterCallBack = true;
                        }
                        break;
                    //case "Anthem.CheckBox": ((Anthem.CheckBox)p_Form.FindControl(arrCampos[intCount])).Checked = false; break;

                    //case "Anthem.DataGrid":
                    //    ((Anthem.DataGrid)p_Form.FindControl(arrCampos[intCount])).DataSource = null;
                    //    ((Anthem.DataGrid)p_Form.FindControl(arrCampos[intCount])).DataBind();
                    //    break;

                    case "Anthem.HiddenField":
                        ((Anthem.HiddenField)ctr).Value = "";
                        ((Anthem.HiddenField)ctr).UpdateAfterCallBack = true;
                        break;
                }
            }
        }
    }

    public void TextChangeWithStored(System.Web.UI.Page p_Form, string[] arrCampos,string strStoredName, SqlParameter[] arr, string strNextControlFocus)
    {
        try
        {
            using (DataSet ds = Contabilidad.DataAccess.Base.ExecuteStored(strStoredName, arr))
            {
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        DataRow row = ds.Tables[0].Rows[0];

                        for (int intCount = 0; intCount <= arrCampos.Length - 1; intCount++)
                        {
                            Control ctr = FindControlRecursive(p_Form, arrCampos[intCount]);
                            if (ctr != null)
                            {
                                switch (ctr.GetType().ToString())
                                {
                                    case "Anthem.TextBox":

                                        ((Anthem.TextBox)ctr).Text = row[intCount].ToString();
                                        ((Anthem.TextBox)ctr).UpdateAfterCallBack = true;

                                        break;

                                    case "Anthem.DropDownList":
                                        if (((Anthem.DropDownList)ctr).Items.Count > 0)
                                        {
                                            ((Anthem.DropDownList)ctr).SelectedValue = row[intCount].ToString();
                                            ((Anthem.DropDownList)ctr).UpdateAfterCallBack = true;
                                        }
                                        break;
                                        //case "Anthem.CheckBox": ((Anthem.CheckBox)p_Form.FindControl(arrCampos[intCount])).Checked = false; break;

                                        //case "Anthem.DataGrid":
                                        //    ((Anthem.DataGrid)p_Form.FindControl(arrCampos[intCount])).DataSource = null;
                                        //    ((Anthem.DataGrid)p_Form.FindControl(arrCampos[intCount])).DataBind();
                                        //    break;

                                        case "Anthem.HiddenField":
                                            ((Anthem.HiddenField)ctr).Value = row[intCount].ToString();
                                            ((Anthem.HiddenField)ctr).UpdateAfterCallBack = true;
                                            break;
                                    }
                                }
                            }

                        Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "focus", "document.all('" + strNextControlFocus + "').focus();", true);

                            return;
                        }
                        else
                        Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "focus", "document.all('" + FindControlRecursive(p_Form, arrCampos[0]).ClientID + "').focus();", true);
                    }
                    else
                    Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "focus", "document.all('" + FindControlRecursive(p_Form, arrCampos[0]).ClientID + "').focus();", true);
                } 
                 
            }
            catch (System.IO.IOException ex) { } 
    }

    public static Control FindControlRecursive(Control control, string id)
    {
        if (control == null || id == null) return null;
        Control ctrl = control.FindControl(id);

        if (ctrl == null)
        { 
            foreach (Control child in control.Controls)
            {
                ctrl = FindControlRecursive(child, id);

                if (ctrl != null) break;
            }
        }
        return ctrl;
    } 

    public enum DateInterval { Second, Minute, Hour, Day, Week, Month, Quarter, Year }
    public static long DateDiff(DateInterval Interval, System.DateTime StartDate, System.DateTime EndDate)
    {
        long lngDateDiffValue = 0;
        System.TimeSpan TS = new System.TimeSpan(EndDate.Ticks - StartDate.Ticks);
        switch (Interval)
        {
            case DateInterval.Day:
                lngDateDiffValue = (long)TS.Days;
                break;
            case DateInterval.Hour:
                lngDateDiffValue = (long)TS.TotalHours;
                break;
            case DateInterval.Minute:
                lngDateDiffValue = (long)TS.TotalMinutes;
                break;
            case DateInterval.Month:
                lngDateDiffValue = (long)(TS.Days / 30);
                break;
            case DateInterval.Quarter:
                lngDateDiffValue = (long)((TS.Days / 30) / 3);
                break;
            case DateInterval.Second:
                lngDateDiffValue = (long)TS.TotalSeconds;
                break;
            case DateInterval.Week:
                lngDateDiffValue = (long)(TS.Days / 7);
                break;
            case DateInterval.Year:
                lngDateDiffValue = (long)(TS.Days / 365);
                break;
        }
        return (lngDateDiffValue);
    }

    public static int getEdad(DateTime datNacimiento)
    {
        //Se calcula la Edad Actual A partir de la fecha actual Sustrayendo la fecha de nacimiento
        //esto devuelve un TimeSpan por tanto tomaremos los Dias y lo dividimos en 365 días
        int edad = (DateTime.Now.Subtract(datNacimiento).Days / 365);

        return edad;
    }

    public static string unFormat(string p_strValue)
    {
        return p_strValue.Replace("$", string.Empty).Replace(",", string.Empty).Replace("%", string.Empty);
    }

    public static void deshabilita(System.Web.UI.Page p_Form, Object obj, bool blEstatus)
    {
        string strLabel;
        strLabel = "lbl";

        switch (obj.GetType().ToString())
        {
            case "Anthem.TextBox":

                Anthem.TextBox txtControl = (Anthem.TextBox)(obj);
                txtControl.ReadOnly = !blEstatus;
                if (blEstatus)
                    txtControl.BackColor = System.Drawing.Color.White;
                else
                    txtControl.BackColor = System.Drawing.Color.FromArgb(204, 204, 204);

                txtControl.UpdateAfterCallBack = true;

                strLabel += txtControl.ID.ToString().Substring(3);

                break;

            case "Anthem.DropDownList":

                Anthem.DropDownList cboControl = (Anthem.DropDownList)(obj);
                cboControl.Enabled = blEstatus;
                if (blEstatus)
                    cboControl.BackColor = System.Drawing.Color.White;
                else
                    cboControl.BackColor = System.Drawing.Color.FromArgb(204, 204, 204);

                cboControl.UpdateAfterCallBack = true;
                strLabel += cboControl.ID.ToString().Substring(3);

                break;
            case "Anthem.CheckBox":
                Anthem.CheckBox chkControl = ((Anthem.CheckBox)(obj));
                chkControl.Enabled = blEstatus;
                if (blEstatus)
                    chkControl.BackColor = System.Drawing.Color.White;
                else
                    chkControl.BackColor = System.Drawing.Color.FromArgb(204, 204, 204);

                chkControl.UpdateAfterCallBack = true;
                strLabel += chkControl.ID.ToString().Substring(3);
                break;

            //case "Anthem.DataGrid":
            //    ((Anthem.DataGrid)p_Form.FindControl(arrCampos[intCount])).DataSource = null;
            //    ((Anthem.DataGrid)p_Form.FindControl(arrCampos[intCount])).DataBind();
            //    break;

            case "Anthem.RadioButtonList":

                Anthem.RadioButtonList rblControl = ((Anthem.RadioButtonList)(obj));
                rblControl.Enabled = blEstatus;
                if (blEstatus)
                    rblControl.BackColor = System.Drawing.Color.White;
                else
                    rblControl.BackColor = System.Drawing.Color.FromArgb(204, 204, 204);

                rblControl.UpdateAfterCallBack = true;
                strLabel += rblControl.ID.ToString().Substring(3);
                break;
        }


        //Control ctr = FindControlRecursive(p_Form, strLabel);

        //if (ctr != null && obj.GetType().ToString() == "Anthem.Label")
        //{ 
        //    ((Anthem.Label)ctr).Enabled = blEstatus;

        //    if (blEstatus)
        //        ((Anthem.Label)ctr).Font.Bold = true;
        //    else
        //        ((Anthem.Label)ctr).Font.Bold = false;

        //    ((Anthem.Label)ctr).UpdateAfterCallBack = true; 
        //} 

    }

    public static string isNullString(string p_strValue, string p_SeteaPor)
    {
        string strResultado = String.Empty;
        p_SeteaPor = p_SeteaPor.Equals(String.Empty) ? "" : p_SeteaPor;

        if ((p_strValue == null) || (p_strValue == "undefined"))
            strResultado = String.Empty;
        else
            strResultado = p_strValue.Equals(String.Empty) ? p_SeteaPor : p_strValue;

        return strResultado;
    }

    public static void retornaValor(System.Web.UI.Page p_Form, string p_strValor)
    {

        if (!p_Form.ClientScript.IsStartupScriptRegistered("retornaValor"))
            p_Form.ClientScript.RegisterStartupScript(p_Form.GetType(), "retornaValor", "<SCRIPT language='javascript'>window.returnValue='" + p_strValor + "';window.close();</SCRIPT>");

    }

    public static void retornaValorAnthem(System.Web.UI.Page p_Form, string p_strValor)
    {
        //if (!p_Form.ClientScript.IsStartupScriptRegistered("retornaValor"))
        Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "retornaValor", "<SCRIPT language='javascript'>window.returnValue='" + p_strValor + "'; window.close();</SCRIPT>");

    }

    public static void retornaVal(System.Web.UI.Page p_Form, string p_strValor)
    {
        //if (!p_Form.ClientScript.IsStartupScriptRegistered("retornaValor"))
        //Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "retornaValor", "<SCRIPT language='javascript'>window.returnValue='" + p_strValor + "'; window.close();</SCRIPT>");
        Anthem.Manager.RegisterStartupScript(p_Form.GetType(), "retornaValor", "<SCRIPT language='javascript'> window.opener.ReturnVal('" + p_strValor + "');window.close(); </SCRIPT>");

    }

    #region toLetter
    public static string toLetter(string num)
    {
        string res, dec = "";
        Int64 entero;
        int decimales;
        double nro;
        try
        {
            nro = Convert.ToDouble(num);
        }
        catch
        {
            return "";
        }

        entero = Convert.ToInt64(Math.Truncate(nro));
        decimales = Convert.ToInt32(Math.Round((nro - entero) * 100, 2));
        if (decimales > 0)
        {
            dec = " CON " + decimales.ToString() + "/100";
        }
        res = toText(Convert.ToDouble(entero)) + dec;
        return res;
    }

    private static string toText(double value)
    {
        string Num2Text = "";
        value = Math.Truncate(value);
        if (value == 0) Num2Text = "CERO";
        else if (value == 1) Num2Text = "UNO";
        else if (value == 2) Num2Text = "DOS";
        else if (value == 3) Num2Text = "TRES";
        else if (value == 4) Num2Text = "CUATRO";
        else if (value == 5) Num2Text = "CINCO";
        else if (value == 6) Num2Text = "SEIS";
        else if (value == 7) Num2Text = "SIETE";
        else if (value == 8) Num2Text = "OCHO";
        else if (value == 9) Num2Text = "NUEVE";
        else if (value == 10) Num2Text = "DIEZ";
        else if (value == 11) Num2Text = "ONCE";
        else if (value == 12) Num2Text = "DOCE";
        else if (value == 13) Num2Text = "TRECE";
        else if (value == 14) Num2Text = "CATORCE";
        else if (value == 15) Num2Text = "QUINCE";
        else if (value < 20) Num2Text = "DIECI" + toText(value - 10);
        else if (value == 20) Num2Text = "VEINTE";
        else if (value < 30) Num2Text = "VEINTI" + toText(value - 20);
        else if (value == 30) Num2Text = "TREINTA";
        else if (value == 40) Num2Text = "CUARENTA";
        else if (value == 50) Num2Text = "CINCUENTA";
        else if (value == 60) Num2Text = "SESENTA";
        else if (value == 70) Num2Text = "SETENTA";
        else if (value == 80) Num2Text = "OCHENTA";
        else if (value == 90) Num2Text = "NOVENTA";
        else if (value < 100) Num2Text = toText(Math.Truncate(value / 10) * 10) + " Y " + toText(value % 10);
        else if (value == 100) Num2Text = "CIEN";
        else if (value < 200) Num2Text = "CIENTO " + toText(value - 100);
        else if ((value == 200) || (value == 300) || (value == 400) || (value == 600) || (value == 800)) Num2Text = toText(Math.Truncate(value / 100)) + "CIENTOS";
        else if (value == 500) Num2Text = "QUINIENTOS";
        else if (value == 700) Num2Text = "SETECIENTOS";
        else if (value == 900) Num2Text = "NOVECIENTOS";
        else if (value < 1000) Num2Text = toText(Math.Truncate(value / 100) * 100) + " " + toText(value % 100);
        else if (value == 1000) Num2Text = "MIL";
        else if (value < 2000) Num2Text = "MIL " + toText(value % 1000);
        else if (value < 1000000)
        {
            Num2Text = toText(Math.Truncate(value / 1000)) + " MIL";
            if ((value % 1000) > 0) Num2Text = Num2Text + " " + toText(value % 1000);
        }
        else if (value == 1000000) Num2Text = "UN MILLON";
        else if (value < 2000000) Num2Text = "UN MILLON " + toText(value % 1000000);
        else if (value < 1000000000000)
        {
            Num2Text = toText(Math.Truncate(value / 1000000)) + " MILLONES ";
            if ((value - Math.Truncate(value / 1000000) * 1000000) > 0) Num2Text = Num2Text + " " + toText(value - Math.Truncate(value / 1000000) * 1000000);
        }
        else if (value == 1000000000000) Num2Text = "UN BILLON";
        else if (value < 2000000000000) Num2Text = "UN BILLON " + toText(value - Math.Truncate(value / 1000000000000) * 1000000000000);
        else
        {
            Num2Text = toText(Math.Truncate(value / 1000000000000)) + " BILLONES";
            if ((value - Math.Truncate(value / 1000000000000) * 1000000000000) > 0) Num2Text = Num2Text + " " + toText(value - Math.Truncate(value / 1000000000000) * 1000000000000);
        }
        return Num2Text;
    }
    #endregion

    #region JQGrid Methods

    public static DataTable getDataFromHelpQuery(int intEmpresa, int intSucursal, string[] parametros, int version, string strClassName)
    {
        DataTable dt = new DataTable();
        Type t = System.Web.Compilation.BuildManager.GetType("Contabilidad.DataAccess." + strClassName, true, true);
        Base objBase = (Base)Activator.CreateInstance(t);
        using (DataSet ds = objBase.QueryHelpData(intEmpresa, intSucursal, parametros, version))
        {
            if (ds != null)
                if (ds.Tables.Count > 0)
                    if (ds.Tables[0].Rows.Count > 0)
                        dt = ds.Tables[0];
        }

        return dt;
    }

    public static DataTable getData(int intEmpresa, int intSucursal, string[] parametros, int version, string strClassName)
    {
        DataTable dt = new DataTable();
        Type t = System.Web.Compilation.BuildManager.GetType("Contabilidad.DataAccess." + strClassName, true, true);
        Base objBase = (Base)Activator.CreateInstance(t);
        using (DataSet ds = objBase.QueryHelpData(intEmpresa, intSucursal, parametros, version))
        {
            if (ds != null)
                if (ds.Tables.Count > 0)
                    if (ds.Tables[0].Rows.Count > 0)
                        dt = ds.Tables[0];
        }


        return dt;
    }

    public static DataSet getDataFromHelpQueryDS(int intEmpresa, int intSucursal, string[] parametros, int version, string strClassName)
    {

        Type t = System.Web.Compilation.BuildManager.GetType("Contabilidad.DataAccess." + strClassName, true, true);
        Base objBase = (Base)Activator.CreateInstance(t);
        using (DataSet ds = objBase.QueryHelpData(intEmpresa, intSucursal, parametros, version))
        {
            if (ds != null)
                if (ds.Tables.Count > 0)
                    if (ds.Tables[0].Rows.Count > 0)
                        return ds;
        }


        return null;
    }

    public static void getStrings(DataTable dt, Array ArrayHideColumns, out StringBuilder dataColumns, out StringBuilder colModel, out StringBuilder dataList)
    {
        int rows;
        int count = 0;
        int count2 = 0;
        int countColumn = 0;

        dataList = new StringBuilder();
        dataColumns = new StringBuilder();
        colModel = new StringBuilder();

        //dt = llamada.GetListBook();
        rows = dt.Rows.Count;
        countColumn = dt.Columns.Count;

        foreach (DataColumn column in dt.Columns)
        {
            count = count + 1;
            if (ArrayHideColumns != null)
                if (Array.IndexOf(ArrayHideColumns, column.ColumnName) >= 0)
                {
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:10," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                    dataColumns.Append("'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',");
                    continue;
                }

            switch (column.ColumnName.Length > 3 ? column.ColumnName.Substring(0, 3) : column.ColumnName)
            {
                case "hdd":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:10," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                    dataColumns.Append("'" + column.ColumnName.Trim().Substring(3, column.ColumnName.Trim().Length - 3) + "',");
                    break;
                case "img":
                case "btn":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:18," + TypeValue(column.DataType.ToString()) + " },");
                    dataColumns.Append("' ',");
                    break;
                case "chk":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:20,editable:true, edittype:'checkbox', editoptions: { value:'True:False'}, formatter: 'checkbox', formatoptions: {disabled : false} },");
                    dataColumns.Append("' ',");
                    break;
                case "dtp":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:60,editable:true, edittype:'text', editoptions: {dataInit: function(el) { setTimeout(function() { $(el).datepicker(); }, 200); } }},");
                    dataColumns.Append("' ',");
                    break;
                case "tmp":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:45,editable:true, edittype:'text', editoptions: {dataInit: function (tm) {$(tm).datetimepicker({ dateFormat: 'yy-mm-dd' });}}}");
                    dataColumns.Append("' ',");
                    break;
                case "mon":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + Size(column.ColumnName, "0") + "," + TypeValue(column.DataType.ToString()) + ",formatter:'currency', formatoptions:{decimalSeparator:\".\", thousandsSeparator: \",\", decimalPlaces: 2, prefix: \"$ \"} },");
                    dataColumns.Append("'" + column.ColumnName.Trim().Substring(3, column.ColumnName.Trim().Length - 3) + "',");
                    break;

                //case 2: 
                //    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:20,editable:true, edittype:'checkbox', editoptions: { value:'True:False'}, formatter: 'checkbox', formatoptions: {disabled : false} },");
                //    break;
                default:
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + Size(column.ColumnName, "0") + "," + TypeValue(column.DataType.ToString()) + " },");
                    dataColumns.Append("'" + column.ColumnName.Trim() + "',");
                    break;
            }
        }

        count = 0;

        dataList.Append("");
        foreach (DataRow row in dt.Rows)
        {
            count = count + 1;
            count2 = 0;
            string strFinal = "',";

            dataList.Append("{");
            foreach (DataColumn column in dt.Columns)
            {
                count2 = count2 + 1;
                if (count2 == countColumn)
                    strFinal = "'";
                else
                    strFinal = "',";

                switch (column.ColumnName.Length > 3 ? column.ColumnName.Substring(0, 3) : column.ColumnName)
                {
                    case "img":
                        dataList.Append("'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "':'" + row[column.ColumnName].ToString().Replace(Environment.NewLine, " ") + strFinal);
                        break;
                    default:
                        dataList.Append("'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "':'" + row[column.ColumnName].ToString().Replace(Environment.NewLine, " ") + strFinal);
                        break;
                }
            }

            if (count == rows)
                dataList.Append("}");
            else
                dataList.Append("},");
        }

        // dataList.Append("]"); 
    }

    public static void getStrings(DataSet ds, Array ArrayHideColumns, out StringBuilder dataColumns, out StringBuilder colModel, out StringBuilder dataList)
    {
        int rows;
        int count = 0;
        int count2 = 0;
        int countColumn = 0;

        dataList = new StringBuilder();
        dataColumns = new StringBuilder();
        colModel = new StringBuilder();

        DataTable dt = ds.Tables[0];
        rows = dt.Rows.Count;
        countColumn = dt.Columns.Count;
        bool bSizeColumns = false;
        if (ds.Tables.Count > 1)
            bSizeColumns = true;

        string strSizeColumn = "0";
        string strHeaderName = string.Empty;
        foreach (DataColumn column in dt.Columns)
        {
            count = count + 1;
            strSizeColumn = "0";
            if (ArrayHideColumns != null)
                if (Array.IndexOf(ArrayHideColumns, column.ColumnName) >= 0)
                {
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:10," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                    dataColumns.Append("'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',");
                    continue;
                }

            if (bSizeColumns)
                if (ds.Tables[1].Rows[0].Table.Columns.Contains(column.ColumnName))
                    strSizeColumn = ds.Tables[1].Rows[0][column.ColumnName].ToString();



            switch (column.ColumnName.Length > 3 ? column.ColumnName.Substring(0, 3) : column.ColumnName)
            {
                case "hdd":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:10," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                    dataColumns.Append("'" + getHeaderName(column.ColumnName.Trim().Substring(3, column.ColumnName.Trim().Length - 3)) + "',");
                    break;
                case "img":
                case "btn":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + (strSizeColumn == "0" ? "18" : strSizeColumn) + "," + TypeValue(column.DataType.ToString()) + " },");
                    dataColumns.Append("' ',");
                    break;
                case "mon":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + Size(column.ColumnName, strSizeColumn) + "," + TypeValue(column.DataType.ToString()) + ",formatter:'currency', formatoptions:{decimalSeparator:\".\", thousandsSeparator: \",\", decimalPlaces: 2, prefix: \"$ \"} },");
                    dataColumns.Append("'" + getHeaderName(column.ColumnName.Trim().Substring(3, column.ColumnName.Trim().Length - 3)) + "',");
                    break;
                case "chk":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:20,editable:true, edittype:'checkbox', editoptions: { value:'True:False'}, formatter: 'checkbox', formatoptions: {disabled : false} },");
                    dataColumns.Append("' ',");
                    break;
                case "dtp":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:60, template: dateTemplate },");
                    dataColumns.Append("' ',");
                    break;
                case "tmp":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:45,editable:true, edittype:'text', editoptions: {dataInit: function (tm) {$(tm).datetimepicker({ dateFormat: 'yy-mm-dd' });}}}");
                    dataColumns.Append("' ',");
                    break;
                case "int":
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + Size(column.ColumnName, strSizeColumn) + "," + TypeValue(column.DataType.ToString()) + ",formatter:'integer',formatoptions:{decimalSeparator:\"\", thousandsSeparator: \"\", decimalPlaces: 0, defaultValue: '0'} },");
                    dataColumns.Append("'" + getHeaderName(column.ColumnName.Trim().Substring(3, column.ColumnName.Trim().Length - 3)) + "',");
                    break;

                default:
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + Size(column.ColumnName, strSizeColumn) + "," + TypeValue(column.DataType.ToString()) + " },");
                    dataColumns.Append("'" + getHeaderName(column.ColumnName.Trim()) + "',");
                    break;
            }
        }

        count = 0;

        dataList.Append("");
        foreach (DataRow row in dt.Rows)
        {
            count = count + 1;
            count2 = 0;
            string strFinal = "',";

            dataList.Append("{");
            foreach (DataColumn column in dt.Columns)
            {
                count2 = count2 + 1;
                if (count2 == countColumn)
                    strFinal = "'";
                else
                    strFinal = "',";

                switch (column.ColumnName.Length > 3 ? column.ColumnName.Substring(0, 3) : column.ColumnName)
                {
                    case "img":
                        dataList.Append("'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "':'" + row[column.ColumnName].ToString().Replace(Environment.NewLine, " ") + strFinal);
                        break;
                    default:
                        dataList.Append("'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "':'" + row[column.ColumnName].ToString().Replace(Environment.NewLine, " ") + strFinal);
                        break;
                }
            }

            if (count == rows)
                dataList.Append("}");
            else
                dataList.Append("},");
        }

        // dataList.Append("]"); 
    }

    #region getHeaderName
    public static string getHeaderName(string strHeader)
    {
        //if (strHeader.IndexOf(" ") != -1)
        //{
        //    string[] arr = strHeader.Split(' ');
        //    strHeader = string.Empty;
        //    strHeader = "<div style=\"height: 40px; padding: 4px 0;\">";
        //    foreach (string val in arr)
        //    {
        //        strHeader += "<span>" + val + "</span><br />";
        //    }
        //    strHeader = strHeader.Substring(0, strHeader.Length - 6);
        //    strHeader += "</div>";
        //}


        return strHeader;
    }
    #endregion

    #region Size
    private static string Size(string data, string strSizeColumn)
    {
        string result = "";


        if (strSizeColumn != "0")
            return strSizeColumn;


        if (data.ToUpper().Contains("FECHA"))
            result = "65";
        else
        {
            if (data.ToUpper().Contains("#"))
                result = "40";
            else
            {
                if (data.ToUpper().Contains("CLIENTE"))
                    result = "200";
                else
                    result = "100";
            }
        }

        return result;
    }
    #endregion

    #region TypeValue
    private static string TypeValue(string data)
    {
        string result = "";
        switch (data)
        {
            case "System.String":
                result = "align: 'Left'";
                break;
            case "System.Boolean":
                result = "align: 'Center'";
                break;
            case "System.DateTime":
                result = "align: 'Center',sorttype: 'date', datefmt: 'd/M/Y'";
                break;
            case "System.Decimal":
                result = "align: 'Right',sorttype: 'numeric'";
                break;
            case "System.Double":
                result = "align: 'Right',sorttype: 'numeric'";
                break;
            case "System.Int32":
                result = "align: 'Right',sorttype: 'int'";
                break;
            case "System.Int16":
                result = "align: 'Right',sorttype: 'int'";
                break;
            case "System.Int64":
                result = "align: 'Right',sorttype: 'int'";
                break;
        }
        return result;
    }
    #endregion

    #endregion


    #region Function XML
    #region RemoveAllNamespaces
    public static XmlDocument RemoveAllNamespaces(XmlDocument doc)
    {
        XDocument d;
        using (var nodeReader = new XmlNodeReader(doc))
            d = XDocument.Load(nodeReader);

        //d.Root.Descendants().Attributes().Where(x => x.IsNamespaceDeclaration).Remove();
        foreach (var elem in d.Descendants())
            elem.Name = elem.Name.LocalName;

        var xmlDocument = new XmlDocument();
        using (var xmlReader = d.CreateReader())
            xmlDocument.Load(xmlReader);
        return xmlDocument;
    }
    #endregion

    #region GetValueAttribute
    public static string GetValueAttribute(XmlDocument doc, string strNode, string[] arrAttribute)
    {
        string strValue = "";
        XmlNode objNode;

        objNode = doc.DocumentElement[strNode];
        if (objNode == null)
            objNode = doc.DocumentElement;

        //Recorre el arreglo de string hasta encontrar el primer valor
        strValue = GetValueAttribute(objNode, arrAttribute);
        return strValue;
    }
    #endregion

    #region GetValueAttribute
    public static string GetValueAttribute(XmlNode root, string[] arrAttribute)
    {
        string str = "";
        try
        {

            //Se recorren todos los atributos del nodo principal
            for (int i = 0; i < root.Attributes.Count; i++)
            {
                string strAtributo = root.Attributes[i].Name.ToLower();
                // se busca en el arreglo de string el atributo
                string[] result = Array.FindAll(arrAttribute, a => a.Equals(strAtributo, StringComparison.CurrentCultureIgnoreCase));
                if (result.Length > 0) //Si se encuentra el atributo se retorna el valor
                {
                    str = root.Attributes[i].Value;
                    return str;
                }
            }

            //Se recorren los nodos
            for (int i = 0; i < root.ChildNodes.Count; i++)
            {
                XmlNode childNode = root.ChildNodes[i];
                str = GetValueAttribute(childNode, arrAttribute);
                if (str != "")
                    return str;
            }
        }
        catch { }
        return str;
    }
    #endregion

    #endregion


}
