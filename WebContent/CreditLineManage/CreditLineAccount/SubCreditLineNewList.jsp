 <%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<!DOCTYPE>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/js/jquery/jquery.treeTable.extends.js"></script>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.css"></link>
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/CustomerManage/GroupManage/resources/css/jquery.treeTable.extends.css"></link>
<style type="text/css">
 body{font-size:14px;}
 .treetable{font-size:12px;margin:10px;width:99%;border:none;}
 .treetable thead tr th{padding:6px 20px 6px auto;font-size:14px;font-weight: bold;border:none;border-top: 1px solid #369;border-bottom: 1px solid #369;}
 .treetable tbody tr td{padding:3px 20px 3px auto;border-bottom: 1px dotted #369;}
/*已移除*/
.treetable tbody tr.removed td{text-decoration:line-through;color: #F00;}
/*在被删除的行里，去除该单元格的删除线*/
.treetable tbody tr.removed .noremoved{text-decoration:none;}
/*修改过*/
.treetable tbody tr.changed td{color: #00F;}
/*新建立*/
.treetable tbody tr.new td{color:#008000;}
.newbutton{padding:2px;text-decoration: none;}
.newbutton:hover{color:#F00;}

/*-------------------------------------*/
.mydiv{font-size:14px;padding:3px;}
#normalAction,#revisionAction{text-decoration: none;padding:2px;}
#normalAction:hover,#revisionAction:hover{color:#DAA520;}
.actived{border:1px solid #B0C4DE;background-color: #FAFAD2;}
</style>
<body> 
<%

String sButtons[][] = {
		   {"true","","Button","额度分配","额度分配","viewAndEdit()","","","",""},
		   {"true","","Button","详情","详情","viewAndEdit()","","","",""},
		   {"true","","Button","删除","删除","viewHistory()","","","",""}
};


%>
<div id="buttonBar">
<table>
	<tr height=1 id="ButtonTR"> 
		<td id="ListButtonArea" class="ListButtonArea" valign=top> 
			<%@ include file="/Frame/page/jspf/ui/widget/buttonset_dw.jspf"%>
		</td>
	</tr>
</table>
</div>


<form id='backProcess' name='backProcess' style='display:none'>
<input type='hidden' name='contextSerial' id='contextSerial' value='1F8B08000000000000009D56EB4F5C45149F7DC1B2804209B6B15625C6E8A77BF7EEF20CC6020BC8EA16B080927E72D81D76D7DEBDF7766616163F18DB447CC4261263526C4CA5561313A52555400989C6443FD5443F9A7E32DD6531EA3FE017CFDCC73E7824969BDC7377CE9C39E7FCCE6BF6CBBF918F51743AAE67249CC194E9B35CC28621619549F12CE37A86502949F5AC21714A88048286AE118D4BC3384E5844D738C9F17F97A62EDFFDE74EBD1BF962A80E734ED333594E387A30F62A9EC37296A755F90C367A63E8819286088EA7C805F43A72C11935CD38D108651C35559C89011B0EF93384319C24CC166FA4BACE238E228EFA62A0557600C800400600B203403601C802805C322F4F454B1A7A730644A159D895845D6904B314F8EBABFDFD871F1F7AE5570F720FA380AAE304A0E63A8DA23A9EA284A5743591334EF721F134CCFB8136C1EBE2A86684E004A11C9DDCBDBA98BF7A3DBF7ABDF0F6467E75BD786BADF0C9D2CED6D785776FE44C3CBE7DE7BD1084505009073B95EEA0F92861F0AFFF4859CAA4D58549608EEA09D2D6F6F2894B3F5DFDC38DFC8328C052989297B09A259080FE44E22CC10CF2898E590950B196942720955A1252D090219919422380293A28DC6E805C9679930B06B1B9018B3B8A337B381532C70C30ADF1B344C53CAD6B153B3EC631B716398A7A8F00D901AB1597A53FC9A377DCC80D6A553C4354DB86DFB21E4D38669E3D82998AF2597C7EFBAF676E7D3F0EE57F0EF9E7D22C8D675408AA3F9E4AAB093025EC8013B571AB5D38EA3F4AC156761C64C49D4ED8786A2C3C62E5C9192E2895967229F7538A17441FE52EFE766AF967FCB107B9A2C8CBD2AF919C21EA6EDE0B249013A7BD8204CCAAAC77999F66D8F3581262D9B477AFEAF4BEB26D0F0B7E0B4768DF56A8ABAFDD2C7BD8F20695A022244F9884A386FC8D2F0AEB378B9756EE6D6D73E40E86045138AA8D8C0C455E181ABC3F37940ED30D5BF97D3952F866A3B8F66D616DBBB8FDF9418E1C6231D465D81ABCA3903C643FC61EDDCB85B56BBB576EE7DF7CC7546B94F51EC5D7DDB72EE7BF5B2C6EDC2CAC7C7690AF42AE4D90C70479BA1493E382B4E64AC17459C184321AFADF7DF19CF819B137EC1A8D39337DF6E25377DDF5BFB89147F440964E3131194F55F780DD1B72FF84D886FAAE35D5479D220FCC8126981513E482D5B662649FAC72D05621592AEC98BBDCA8F11C0AA4D924CD12C1876107A340D792B1B1015BB7CD18A3498E1E39CC2DD815F7D7AC4E01E238666C5EA78E733E9D264B6311C64BD5661DD5553229460247AD15975BA93341AD979D4FC3E87D72CF5C9827325C337206C6992A4F804894938CB81085F838E629670288A99965CE2A0B304BEED48BD519EB02753C14ACD28086912162F9F021B104DCE550D6019CB84E8DB10ABCB5003E021E1E180B58C4C85C69F40AD98A9BA11E96E35437A01E166C5623352F85395269A286E9948FEA07A0CD19D035AE20BC8AF56D9D9E9ECE7FB8786FF3A3DD0FD68B2BEF15DED8026AD802E66B2F1E8F44C21D5D9D4A6724D2A18407DABB7B3A87BB878706BB43ED03E121A547297544ADD5111C79A00905EDB668A7A03DE6EF9E90497B8042B3E6209E4F5437CF3C91209592994AC9496539B0D01A5EAD1C18AF51915C4A40CBF932DCE3F2300551591401933989A7345DD5930BE67879D10257C309E3C29D9AC2579FE63737E19F88C5B1E2B1737B6B67EBDACEEACACEFB8BF9A52BA549136AB74726A8689EA8E60595C3FEB020730CB6FC07C9B2FE024E0A0000'></input></form>
	<table class='treetable'>
		<thead>
			<tr>
				<th name='memberName' width=10px></th>
				<th name='Sum'>币种</th>
				<th name='shareValue'>名义金额</th>
				<th name='Sum'>敞口金额</th>
				<th name='Sum'>循环标志</th>
				<th name='Sum'>控制方式</th>
				<th name='Sum'>计算方式</th>
				<th name='Sum'>共享规则</th> 
<!--				<th name='Sum'>适用产品</th> -->
<!--				<th name='Sum'>适用机构</th> -->
<!--				<th name='Sum'>适用币种</th> -->
<!--				<th name='Sum'>适用担保</th> -->
<!--				<th name='Sum'>适用主体</th> -->
				
			</tr>
		</thead>
		<tbody>
					<tr id='2013061800000027' class='' nodeData='{"addReason":null,"memberCertType":"","shareValue":0.0,"state":"CHECKED","memberType":"01","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000027","parentId":"None","parentRelationType":null,"visiable":true,"memberName":"浙江阳光"}'>
						<td name='memberName'></td>
						<td name='Sum'>人民币</td>
						<td name='shareValue'>10000</td>
						<td name='Sum'>1000</td>
						<td name='Sum'>循环</td>
						<td name='Sum'>敞口+金额</td>
						<td name='Sum'>A.批准金额</td>
						<td name='Sum'>共享</td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000013' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000013","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"重庆路桥"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000043' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000043","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"天涯股份"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000015' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000015","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"海豹汽车"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
				 
					
					
					<tr id='2013061800000027' class='' nodeData='{"addReason":null,"memberCertType":"","shareValue":0.0,"state":"CHECKED","memberType":"01","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000027","parentId":"None","parentRelationType":null,"visiable":true,"memberName":"浙江阳光"}'>
						<td name='memberName'></td>
						<td name='Sum'>人民币</td>
						<td name='shareValue'>10000</td>
						<td name='Sum'>1000</td>
						<td name='Sum'>循环</td>
						<td name='Sum'>敞口+金额</td>
						<td name='Sum'>A.批准金额</td>
						<td name='Sum'>共享</td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000013' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000013","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"重庆路桥"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000043' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000043","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"天涯股份"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000015' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000015","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"海豹汽车"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					
		</tbody>
	</table> 



<table class='treetable2'>
		<thead>
			<tr>
				<th name='memberName' width=10px></th>
				<th name='Sum'>币种</th>
				<th name='shareValue'>名义金额</th>
				<th name='Sum'>敞口金额</th>
				<th name='Sum'>循环标志</th>
				<th name='Sum'>控制方式</th>
				<th name='Sum'>计算方式</th>
				<th name='Sum'>共享规则</th> 
				<th name='Sum'></th> 
<!--				<th name='Sum'>适用产品</th> -->
<!--				<th name='Sum'>适用机构</th> -->
<!--				<th name='Sum'>适用币种</th> -->
<!--				<th name='Sum'>适用担保</th> -->
<!--				<th name='Sum'>适用主体</th> -->
				
			</tr>
		</thead>
		<tbody>
					<tr id='2013061800000027' class='' nodeData='{"addReason":null,"memberCertType":"","shareValue":0.0,"state":"CHECKED","memberType":"01","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000027","parentId":"None","parentRelationType":null,"visiable":true,"memberName":"浙江阳光"}'>
						<td name='memberName'></td>
						<td name='Sum'>人民币</td>
						<td name='shareValue'>10000</td>
						<td name='Sum'>1000</td>
						<td name='Sum'>循环</td>
						<td name='Sum'>敞口+金额</td>
						<td name='Sum'>A.批准金额</td>
						<td name='Sum'>共享</td> 
						<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td> 
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					
					
					<tr id='2013061800000013d' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000013","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"重庆路桥"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					
					<tr id='zzz' class='child-of-2013061800000013d' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000013","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"重庆路桥"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					
					<tr id='zzz1' class='child-of-zzz' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000013","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"重庆路桥"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					
					<tr id='2013061800000043' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000043","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"天涯股份"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000015' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000015","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"海豹汽车"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
				 
					
					
					<tr id='2013061800000027' class='' nodeData='{"addReason":null,"memberCertType":"","shareValue":0.0,"state":"CHECKED","memberType":"01","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000027","parentId":"None","parentRelationType":null,"visiable":true,"memberName":"浙江阳光"}'>
						<td name='memberName'></td>
						<td name='Sum'>人民币</td>
						<td name='shareValue'>10000</td>
						<td name='Sum'>1000</td>
						<td name='Sum'>循环</td>
						<td name='Sum'>敞口+金额</td>
						<td name='Sum'>A.批准金额</td>
						<td name='Sum'>共享</td> 
						
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000013' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000013","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"重庆路桥"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
							
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000043' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000043","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"天涯股份"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
							
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					<tr id='2013061800000015' class='child-of-2013061800000027' nodeData='{"addReason":"0101","memberCertType":"","shareValue":20.0,"state":"CHECKED","memberType":"02","serialversionuid":2387285040267959266,"label":"","memberCertID":"","id":"2013061800000015","parentId":"2013061800000027","parentRelationType":"01","visiable":true,"memberName":"海豹汽车"}'>
					 		<td name='memberName'></td>
							<td name='Sum'>人民币</td>
							<td name='shareValue'>10000</td>
							<td name='Sum'>1000</td>
							<td name='Sum'>循环</td>
							<td name='Sum'>敞口+金额</td>
							<td name='Sum'>A.批准金额</td>
							<td name='Sum'>共享</td> 
							<td name='Sum'><a href='#'>详情</a>  <a href='#'>删除</a>  <a href='#'>分配</a></td>
<!--						<td name='Sum'>流动资金</td> -->
<!--						<td name='Sum'>全行</td> -->
<!--						<td name='Sum'>人民币</td> -->
<!--						<td name='Sum'>保证、抵押</td> -->
<!--						<td name='Sum'>A客户</td> -->
					</tr>
					
		</tbody>
	</table> 
</body>
</html>

<script type="text/javascript">
$(document).ready(function() {
    table = $("table.treetable");
    table2 = $("table.treetable2");
    //生成treeTable
    table.treeTable({initialState:"expanded"});
    //给表绑定移入改变背景，单击高亮事件
    table.tableLight();


    table2.treeTable({initialState:"expanded"});
    //给表绑定移入改变背景，单击高亮事件
    table2.tableLight();
    
 
    return;
});

</script>


<%@ include file="/IncludeEnd.jsp"%>