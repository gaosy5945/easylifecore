import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.sys.SystemConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.XMLHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.Transaction;

public class FunctionConvert {
	public static void main(String[] args) throws Exception{
		//³õÊ¼ARE·þÎñ
		if(!ARE.isInitOk()) ARE.init("D:/WorkSpace/cfs_web/WebContent/WEB-INF/etc/are.xml");
		
		(new SystemConfig()).load(new Transaction("als"));
		
		String XMLFile = "D:/WorkSpace/A3WEB3.5/WebContent/WEB-INF/etc/app/function-config.xml";
		String XMLTags = "function";
		
		String functionids = "PRD_ProductView";
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
		List<BusinessObject> functions = bomanager.loadBusinessObjects("jbo.sys.SYS_FUNCTION_CATALOG", "FunctionID in(:FunctionID)", "FunctionID", functionids.split(","));
		
		for(BusinessObject function:functions)
		{
			BusinessObject f = BusinessObject.createBusinessObject();
			f.setAttributeValue("ID", function.getString("FUNCTIONID"));
			f.setAttributeValue("NAME", function.getString("FUNCTIONNAME"));
			f.setAttributeValue("Status", function.getString("ISINUSE"));
			f.setAttributeValue("URL", function.getString("URL"));
			f.setAttributeValue("EDITSTYLE", function.getString("EDITSTYLE"));
			f.setAttributeValue("RIGHTTYPE", function.getString("RIGHTTYPE"));
			f.setAttributeValue("PARAMETERS", function.getString("PARAMETERS"));
			f.setAttributeValue("INPUTUSERID", function.getString("INPUTUSERID"));
			f.setAttributeValue("INPUTORGID", function.getString("INPUTORGID"));
			f.setAttributeValue("INPUTDATE", function.getString("INPUTDATE"));
			
			List<BusinessObject> ls = new ArrayList<BusinessObject>();
			ls.add(f);
			XMLHelper.saveBusinessObjectList(XMLFile, XMLTags+"||id='"+function.getString("FUNCTIONID")+"'", "ID", ls);
			List<BusinessObject> lss = new ArrayList<BusinessObject>();
			List<BusinessObject> lirs = bomanager.loadBusinessObjects("jbo.sys.SYS_FUNCTION_LIBRARY", "FunctionID=:FunctionID", "FunctionID",function.getString("FUNCTIONID"));
			for(BusinessObject lir:lirs)
			{
				BusinessObject l = BusinessObject.createBusinessObject();
				l.setAttributeValue("ID", lir.getString("SortNo"));
				l.setAttributeValue("NAME", lir.getString("ITEMNAME"));
				l.setAttributeValue("FUNCTIONTYPE", lir.getString("FUNCTIONTYPE"));
				l.setAttributeValue("FUNCTIONSUBTYPE", lir.getString("FUNCTIONSUBTYPE"));
				l.setAttributeValue("SCRIPT", lir.getString("SCRIPT"));
				l.setAttributeValue("Status", lir.getString("ISINUSE"));
				l.setAttributeValue("URL", lir.getString("URL"));
				l.setAttributeValue("RIGHTTYPE", lir.getString("RIGHTTYPE"));
				l.setAttributeValue("PARAMETERS", lir.getString("PARAMETERS"));
				l.setAttributeValue("INPUTUSERID", lir.getString("INPUTUSERID"));
				l.setAttributeValue("INPUTORGID", lir.getString("INPUTORGID"));
				l.setAttributeValue("INPUTDATE", lir.getString("INPUTDATE"));
				lss.add(l);
			}
			
			XMLHelper.saveBusinessObjectList(XMLFile, XMLTags+"||ID='"+function.getString("FUNCTIONID")+"'//item", "ID", lss);
		}
	}
}
