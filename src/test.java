import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.List;

import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.accounting.config.impl.CashFlowConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.BusinessComponentConfig;
import com.amarsoft.app.base.config.impl.CreditCheckConfig;
import com.amarsoft.app.base.config.impl.ErrorCodeConfig;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.script.ScriptConfig;
import com.amarsoft.app.workflow.config.FlowConfig;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.xml.Document;


public class test {

	public static void main(String[] args) throws Exception{
		String str = "<?xml version=\"1.0\" encoding=\"GBK\"?><jbo.sample.SYS_GEN_OBJECTTYPE rptTermID=\"\" Patch=\"\" CONTRACTARTIFICIALNO=\"\" FlowNo=\"\" APPLYTYPE=\"001\" activeCount=\"\" ORGID=\"9900\" CUSTOMERID=\"2016071300000018\" deviceID=\"\" CERTID=\"\" treatPaper=\"\" customerInfo=\"\" activeTime=\"\" marketActive=\"\" CERTTYPE=\"\" BUSINESSPRIORITY=\"99999\" BUSINESSTYPE=\"30\" PRODUCTID=\"30\" CUSTOMERNAME=\"Ö£³É¿­\" org_id=\"9900\" firstPayRatio=\"0.0\" printCount=\"\" occurType=\"\" activeName=\"\" businessSum=\"3000.0\" businessTermMonth=\"\" UserID=\"test11\" />";
		
		InputStream in = new ByteArrayInputStream(str.getBytes("UTF-8"));
		Document document = new Document(in);
		in.close();
		System.out.println(str.getBytes("UTF-8").length);
		System.out.println(str.getBytes("gbk").length);
		
	}

}
