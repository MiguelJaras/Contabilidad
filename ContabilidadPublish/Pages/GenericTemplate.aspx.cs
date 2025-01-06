using System;
using System.Collections;
using System.Configuration;
using System.Data;

using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;


public partial class PageGenericTemplate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String PageContent = this.ResolveUrl("~/Pages/Default.aspx");
        String LoginPage = this.ResolveUrl(FormsAuthentication.LoginUrl);
        if (Request.QueryString["ReturnUrl"] != null)
        {
            PageContent = Request.QueryString["ReturnUrl"];
        }


        System.Text.StringBuilder sbFrame = new System.Text.StringBuilder();
        sbFrame.AppendLine("<html>");
        sbFrame.AppendLine("<head>");
        sbFrame.AppendLine("<title>::: WEGO - PM :::</title>");
        sbFrame.AppendLine("</head>");
        sbFrame.AppendLine("<frameset rows='120,*' scrolling='no' border=0 noresize  marginheight='2' marginwidth='2'  frameborder='0' framespacing='0' >");
        sbFrame.AppendLine("<noframes>");
        sbFrame.AppendLine("<body>");
        sbFrame.AppendLine("Su visualizador no soporta frames. Pulse ");
        sbFrame.AppendLine("<a href='" + LoginPage + "'>aqui</a> para volver.");
        sbFrame.AppendLine("</body>");
        sbFrame.AppendLine("</noframes>");

        sbFrame.AppendLine("<frame Name='Header' SRC='FrameHeader.aspx' scrolling='no' border=0 noresize  marginheight='2' marginwidth='2'  frameborder='0' framespacing='0'  >");
        sbFrame.AppendLine("<frameset id='Columns' cols='20,*'>");
        sbFrame.AppendLine("<frame id='Menu' Name='Menu' SRC='FrameMenu.aspx'  scrolling='no' border=0 noresize marginheight='2' marginwidth='2'  frameborder='0' framespacing='0'  >");
        sbFrame.AppendLine("<frame Name='Content' src='" + PageContent + "'  border=0 noresize marginheight='2' marginwidth='2'  frameborder='0' framespacing='0'   >");
        sbFrame.AppendLine("</frameset>");
        sbFrame.AppendLine("</frameset>");
        sbFrame.AppendLine("</html>");

        Response.Write(sbFrame.ToString());
        Response.End();
    }
}
