package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.config.impl.SystemDBConfig;

public class GetParticipantGiveoutlist implements IProcess{

	@Override
	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager,
			String paraName, String dataType, BusinessObject otherPara)
			throws Exception {
		String roleID = "PLBS0018";
		String giveoutOrgIDs = otherPara.getString("GiveoutOrgID");
		String[] giveoutOrgID = giveoutOrgIDs.split("@");
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("&lt;list&gt;");
		for(int i=0;i<giveoutOrgID.length;i++){
			
			String orgListID = giveoutOrgID[i];
			BusinessObject orgInfo = SystemDBConfig.getOrg(orgListID);
			String orgListName = orgInfo.getString("OrgName")+"ÉóºË¸Ú";
			String participantlist = roleID+"$"+orgListID;
			
			sb.append("&lt;Participant&gt;");
			sb.append("&lt;id&gt;"+participantlist+"&lt;/id&gt;");
			sb.append("&lt;name&gt;"+orgListName+"&lt;/name&gt;");
			sb.append("&lt;type&gt;POST&lt;/type&gt;");
			sb.append("&lt;/Participant&gt;");
		}
		sb.append("&lt;/list&gt;");
		
		return sb.toString();
	}
	
}
