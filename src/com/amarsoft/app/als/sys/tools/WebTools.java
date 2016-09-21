package com.amarsoft.app.als.sys.tools;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.util.SpecialTools;
import com.amarsoft.awe.RuntimeContext;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.control.model.ComponentSession;
import com.amarsoft.awe.control.model.Parameter;
import com.amarsoft.context.ASOrg;
import com.amarsoft.context.ASUser;

public class WebTools {

 
	public static String getPageEndScript(HttpSession session,HttpServletRequest request) throws Exception{
		StringBuffer temp=new StringBuffer();
		RuntimeContext CurARC = (RuntimeContext)session.getAttribute("CurARC");
		if(CurARC == null)  return "";
		ComponentSession CurCompSession = CurARC.getCompSession();
		String sCompClientID = request.getParameter("CompClientID");
		if(sCompClientID==null) sCompClientID="";
	    Component CurComp = CurCompSession.lookUp(sCompClientID);
	    //temp.append("try{\n");
		if(CurComp!=null){
			Vector<Parameter> vlst = CurComp.getParameterList();
			for(int i=0;i<vlst.size();i++){
				String paraName=vlst.get(i).paraName;
				String paraValue=vlst.get(i).paraValue;
				if(!paraName.startsWith("SYS_FUNCTION_")) {
					temp.append("AsCredit.PageSystemParameters[\""+paraName+"\"]=\""+SpecialTools.real2Amarsoft(paraValue)+"\";");
				}
			}
		}
		 ASUser CurUser = CurARC.getUser();
		 if(CurUser!=null){
			 //temp.append("AsCredit.userId=\""+CurUser.getUserID()+"\";");
			 //temp.append("AsCredit.userName=\""+CurUser.getUserName()+"\";");
			 temp.append("AsCredit.PageSystemParameters[\"CurUserID\"]=\""+CurUser.getUserID()+"\";");
			 temp.append("AsCredit.PageSystemParameters[\"CurUserName\"]=\""+CurUser.getUserName()+"\";");
		 }
	     ASOrg CurOrg = CurUser.getBelongOrg();
	   if(CurOrg!=null){
		   //temp.append("AsCredit.orgId=\""+CurUser.getOrgID()+"\";");
		   //temp.append("AsCredit.orgName=\""+CurUser.getOrgName()+"\";");
		   temp.append("AsCredit.PageSystemParameters[\"CurOrgID\"]=\""+CurUser.getOrgID()+"\";");
		  temp.append("AsCredit.PageSystemParameters[\"CurOrgName\"]=\""+CurUser.getOrgName()+"\";");
	   }
	   //temp.append("AsCredit.today=\""+DateHelper.getToday()+"\";");
	   temp.append("AsCredit.PageSystemParameters[\"SystemDate\"]=\""+DateHelper.getBusinessDate()+"\";");
	  // temp.append("}catch(e){\n}");
		return temp.toString();
	}

}
