package com.amarsoft.app.bizmethod;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class DeleteDocCatalog {
	private String viewID;
	private String folderID;
	
	public String getViewID() {
		return viewID;
	}

	public void setViewID(String viewID) {
		this.viewID = viewID;
	}

	public String getFolderID() {
		return folderID;
	}

	public void setFolderID(String folderID) {
		this.folderID = folderID;
	}

	public String deleteDocCatalog(JBOTransaction tx) throws Exception{
		BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.doc.DOC_VIEW_CATALOG");
		tx.join(bom);
		//zhu cai dan shan chu
		String sql1 = "delete  from O where viewid=:viewID and folderid=:folderID";
		BizObjectQuery boq = bom.createQuery(sql1)
				.setParameter("folderID", folderID)
				.setParameter("viewID", viewID);
		int flag = boq.executeUpdate();
		if (flag < 1)
			return 0 + "";
		BizObjectManager bomViewFile = JBOFactory.getBizObjectManager("jbo.doc.DOC_VIEW_FILE");
		tx.join(bomViewFile);
		String sql2 = "select fileid  from O where viewid=:viewID and folderid=:folderID";//��ѯFileId
		BizObjectQuery boq2 = bomViewFile.createQuery(sql2)
					.setParameter("folderID", folderID)
					.setParameter("viewID", viewID);
		@SuppressWarnings("unchecked")
		List<BizObject> bos = boq2.getResultList(false);
		
		String sql3 = "delete  from O where viewid=:viewID and folderid=:folderID";//ɾ�������е�����
		bomViewFile.createQuery(sql3)
					.setParameter("folderID", folderID)
					.setParameter("viewID", viewID)
					.executeUpdate();
		
		
		BizObjectManager bomFileConfig = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_CONFIG");
		tx.join(bomFileConfig);
		
		if(bos != null) {//��ȡ�ļ����
			for(BizObject bo:bos){
			String fileID = bo.getAttribute("fileID").getString();
			String sql4 = "delete  from O where fileID =:fileID";
			bomFileConfig.createQuery(sql4)
						.setParameter("fileID", fileID)
						.executeUpdate();
			}
		}
		
		return 1+"";
	}
	
}
