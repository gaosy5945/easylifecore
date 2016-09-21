package com.amarsoft.app.als.product;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ��Ʒ�ڵ����ƸĶ�����
 * @author lyin 2014-01-26
 *
 */
public class PRDNodeManage {

	//�������
	private String nodeID; //�ڵ���
	private String nodeName; //�ڵ�����

	public String getNodeID() {
		return nodeID;
	}

	public void setNodeID(String nodeID) {
		this.nodeID = nodeID;
	}

	public String getNodeName() {
		return nodeName;
	}

	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}

	/**
	 * ���ڵ������Ƿ��иĶ�
	 * @return
	 * @throws Exception 
	 */
	public String checkNodeName(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;
		String oldNodeName = "";
		
		osql = new SqlObject("select NodeName from PRD_NODEINFO where NodeID = :NodeID");
		osql.setParameter("NodeID", nodeID);
		rs = Sqlca.getASResultSet(osql);
		while(rs.next()){
			oldNodeName = rs.getString("NodeName");
		}
		
		rs.getStatement().close();
        
		if(oldNodeName.equals(nodeName)){
			return "True";
		}else{
			return "False";
		}
	}
	
	/**
	 * ����PRD_NODECONFIG
	 * @return
	 * @throws Exception 
	 */
	public String UpdatePRDNodeConfig(Transaction Sqlca) throws Exception{
		//����PRD_NODECONFIG�нڵ�����
		SqlObject asql = new SqlObject("UPDATE PRD_NODECONFIG SET NODENAME=:NODENAME WHERE NODEID = :NODEID")
		.setParameter("NODEID", nodeID).setParameter("NODENAME", nodeName);
		Sqlca.executeSQL(asql);

		return "SUCCEEDED";
	}
}
