package com.amarsoft.app.als.apply.action;
	/**
	 * 张万亮
	 */
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

	public class DocFileInfo {
		private JSONObject inputParameter;
		private BusinessObjectManager businessObjectManager;
		public void setInputParameter(JSONObject inputParameter){
			this.inputParameter = inputParameter;
		}
		
		private JBOTransaction tx;

		public void setTx(JBOTransaction tx){
			this.tx = tx;
		}
		
		public void setBusinessObjectManager(BusinessObjectManager businessObjectManager){
			this.businessObjectManager = businessObjectManager;
			this.tx = businessObjectManager.getTx();
		}
		
		public void insertDFI(JBOTransaction tx) throws Exception{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_INFO");
			tx.join(bm);
			String ID = (String)inputParameter.getValue("ID");
			String objectNo = (String)inputParameter.getValue("ObjectNo");
			BizObject bo = bm.newObject();
			
			BizObjectManager bm1 = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_CONFIG");
			tx.join(bm1);
			BizObjectQuery boq1 = bm1.createQuery("FILEID=:FILEID").setParameter("FILEID", ID);
			List<BizObject> bos = boq1.getResultList(false);
			if(bos == null || bos.isEmpty()) return;
			bo.setAttributeValue("OBJECTNO", objectNo);
			bo.setAttributeValue("OBJECTTYPE", "contract");
			bo.setAttributeValue("FILEID", ID);
			bo.setAttributeValue("STATUS", "02");
			bo.setAttributeValue("FILEFORMAT", "03");
			bm.saveObject(bo);
		}
		public void delFiles(JBOTransaction tx) throws Exception{
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_INFO");
			tx.join(bm);
			String fileIDs = (String)inputParameter.getValue("FileIDs");
			String objectNo = (String)inputParameter.getValue("ObjectNo");
			if(!StringX.isEmpty(fileIDs)){
				if(fileIDs.endsWith("@")){
					fileIDs = fileIDs.substring(0, fileIDs.length() - 1);
				}
				String[] fileID = fileIDs.split("@");
				for(int i=0; i< fileID.length; i++){
					bm.createQuery("Delete From O Where OBJECTNO =:OBJECTNO and OBJECTTYPE ='contract' and FILEID = :FILEID")
					  .setParameter("OBJECTNO", objectNo).setParameter("FILEID", fileID[i])
					  .executeUpdate();
				}
			}
		}
		/**
		 * 根据合同流水号和业务资料文件编号更新业务资料状态
		 * @param tx
		 * @throws Exception
		 */
		public void updateFileInfoStatus(JBOTransaction tx) throws Exception{
			//1、获取请求参数
			String sStatus = (String) inputParameter.getValue("Status");
			String sContractSerialNo = (String)inputParameter.getValue("ContractSerialNo");
			String sFileID = (String)inputParameter.getValue("FileID");
			//2、获取业务资料信息对象
			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.doc.DOC_FILE_INFO");
			//3、组织更新SQL
			String sSql="update O set Status=:Status where ObjectNo=:ObjectNo and FileID=:FileID";
			
			//4、为占位符赋值
			BizObjectQuery bq = bm.createQuery(sSql).setParameter("Status", sStatus)
								.setParameter("ObjectNo", sContractSerialNo )
								.setParameter("FileID", sFileID );
			//5、执行更新
			bq.executeUpdate();
		}
		public String ifCanDelete(JBOTransaction tx) throws Exception{
			String contractNo = (String)inputParameter.getValue("ContractNo");
			String fileID = (String)inputParameter.getValue("FileID");
			String flag = "true";
			String FileName = "";
			BizObjectManager ba = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
			tx.join(ba);
			BizObjectQuery arq = ba.createQuery("CONTRACTARTIFICIALNO=:ContractNo");
			arq.setParameter("ContractNo", contractNo);
			BizObjectManager bc = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			tx.join(bc);
			BizObjectQuery crq = bc.createQuery("SerialNo=:SerialNo");
			crq.setParameter("SerialNo", contractNo);
			List<BizObject> arboList = arq.getResultList(false);
			if(arboList == null || arboList.isEmpty()){//如果BA搜不到结果就搜BC
				arboList = crq.getResultList(false);//覆盖arboList
			}
			if(arboList != null)
			{
				for(BizObject arbo:arboList){
					String docs = ProductAnalysisFunctions.getComponentMandatoryValue(BusinessObject.convertFromBizObject(arbo), "PRD04-01", "BusinessDocs", "0010", "01");
					if(docs != null && !"".equals(docs)){
						String[] docArray = docs.split(",");
						for(String docID:docArray){
							if(fileID.equals(docID)){
								flag = "false";
								FileName = SYSNameManager.getFileName(docID);
								break;
							}
						}
					}
				}
			}
			return flag+"@"+FileName;
		}
	
}
