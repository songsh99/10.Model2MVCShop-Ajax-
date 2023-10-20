package com.model2.mvc.web.purchase;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.product.ProductService;
import com.model2.mvc.service.product.impl.ProductServiceImpl;
import com.model2.mvc.service.purchase.PurchaseService;
import com.model2.mvc.service.user.UserService;
import com.model2.mvc.web.product.ProductController;



//==> 상품관리 Controller
@Controller
@RequestMapping("/purchase/*")
public class PurchaseController {
	
	///Field
	@Autowired
	@Qualifier("purchaseServiceImpl")
	private PurchaseService purchaseService;
	//setter Method 구현 않음
		
	public PurchaseController(){
		System.out.println(this.getClass());
	}
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	//setter Method 구현 않음
	
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	//Method	
	@RequestMapping(value="addPurchase",method=RequestMethod.GET)
	public String addpurchase(@RequestParam("prodNo") int prodNo, Model model) throws Exception {
		
		System.out.println("addPurchase[GET]\n START ====================================================================");
		
		System.out.println("addPurchase 작동유무 확인 -----------------------!");
		System.out.println("/addPurchase : GET");	
		
		
		Product product = productService.getProduct(prodNo);
		
		System.out.println("========================\n product 정보 잘들어오는 확인좀하자 "+prodNo+"\n========================\n");
		
		System.out.println("product get 정보 가져오기 ++++++++++++++++++++++++++\n"+product);
		
		model.addAttribute("product", product);
		
		System.out.println(model);
		
		System.out.println("addPurchase[GET]\n END ====================================================================");
		
		return "forward:/purchase/addPurchaseView.jsp";
	}

	@RequestMapping(value="addPurchase",method = RequestMethod.POST)
	public String addpurchase(HttpSession session, @ModelAttribute("purchase") Purchase purchase, int prodNo ,Model model,HttpServletRequest request ) throws Exception {
		
		System.out.println("addPurchase[POST]\n START ====================================================================");
		
		System.out.println("/purchase/addpurchase : POST==================================================");
		
		System.out.println("들어오는구만유 ? "+prodNo);
		User user = (User)session.getAttribute("user");
		
		purchase.setBuyer(user);
		purchase.setPurchaseProd(productService.getProduct(Integer.parseInt(request.getParameter("prodNo"))));
		
		System.out.println("왜지 몰까 user"+user);
		purchaseService.addPurchase(purchase);
		
		
		System.out.println("===============================\n"+purchase+"\n purchase 정보 가져오기 ====================");
	
		System.out.println("service 정보 가져오기\n"+purchaseService);
		
		model.addAttribute("purchase", purchase);
		
		System.out.println(model);
		
		System.out.println("/purchase/addpurchase : POST END==================================================");
		
		System.out.println("addPurchase[POST]\n END ====================================================================");
		
		return "forward:/purchase/addPurchase.jsp";
	}

	@RequestMapping(value = "getPurchase", method = RequestMethod.GET)
	public String getPurchase(@RequestParam("tranNo") int tranNo, HttpServletRequest request, Model model,HttpServletResponse response) throws Exception {
		System.out.println("getPurchase\n START ====================================================================");
	    System.out.println("/purchase/getPurchase : GET");
	    System.out.println("GETpurchase get 방식으로 들어왔는지 확인 ===================");
	    // Business Logic
	    System.out.println("tranNo 잘 가져왔는지 확인하기 ================"+tranNo);
	    Purchase purchase = purchaseService.getPurchase(tranNo);
	    System.out.println("숫자를 확인하자 :    " + purchase);
	    
	    // Model과 View 연결
	    model.addAttribute("purchase", purchase);
	    System.out.println("getPurchase\n END ====================================================================");
	    return "forward:/purchase/getPurchase.jsp";
	}

	@RequestMapping(value="listPurchase")
	public String listPurchase(@ModelAttribute("search") Search search,HttpSession session,Model model) throws Exception{
		System.out.println("/purchase/listPurchase Start =========================================================================");
		System.out.println("/purchase/listPurchase : GET / POST");
		
		if(search.getCurrentPage() ==0 ){
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		System.out.println("search================="+search);
		// Business logic 수행
		String buyerId = ((User)session.getAttribute("user")).getUserId();
		//purchaseService.getPurchase(purhcase);
		//Product product = productService.getProduct(prodNo);
		System.out.println("buyerId에대한 정보==========================="+buyerId);
		Map<String ,  Object> map = purchaseService.getPurchaseList(search,buyerId);
		
		System.out.println("map에 대한 정보======="+map);
		
		Page resultPage = new Page( search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize);
		System.out.println(resultPage);
		
		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		
		System.out.println("model에 대한 정보 :::::::   "+model);
		System.out.println("/purchase/listPurchase END =========================================================================");

		return "forward:/purchase/listPurchase.jsp";
	}

	@RequestMapping(value="updatePurchase",method=RequestMethod.GET)
	public String updatePurchase( @RequestParam("tranNo") int tranNo , Model model ) throws Exception{
		
		System.out.println("/purchase/updatePurchase Get 방 식 실행  Start =========================================================================");
		
		System.out.println("/purchase/updatePurchase : GET");
		//Business ]]
		Purchase purchase = purchaseService.getPurchase(tranNo);
		// Model 과 View 연결
		model.addAttribute("purchase", purchase);
		
		System.out.println("updateView get 방식으로 들어왔는지 확인 ===================");
		System.out.println(purchase+"<===================");
		
		System.out.println("/purchase/updatePurchase END =========================================================================");
		
		return "forward:/purchase/updatePurchase.jsp";
	}	
	
	@RequestMapping(value="updatePurchase",method=RequestMethod.POST)		
	public String updatePurchase( @ModelAttribute("purchase") Purchase purchase , Model model , HttpSession session) throws Exception{
		
		System.out.println("/purchase/updatePurchase Post 방 식 실행  Start =========================================================================");
		
		System.out.println("/purchase/updatePurchase : POST");
		//Business Logic
		purchaseService.updatePurchase(purchase);
		 
		System.out.println("updateView post 방식으로 들어왔는지 확인 ==========");
		System.out.println(purchase+"prod 확인문 ::::::::");
		session.setAttribute("purchase", purchase);

		System.out.println("/purchase/updatePurchase END =========================================================================");
		
		return "forward:/purchase/getPurchase.jsp";
	}
	@RequestMapping(value="updateTranCode",method=RequestMethod.GET)		
	public String updateTranCode( @RequestParam("tranNo") int tranNo,@RequestParam("tranCode")String tranCode) throws Exception{
		
		System.out.println("/purchase/TranCode GET 방 식 실행  Start =========================================================================");
		
		
		//Purchase purchase = purchaseService.getPurchase(tranNo);
		System.out.println("tranNo확인하자 : "+tranNo);
		Purchase purchase = purchaseService.getPurchase(tranNo);
		
		purchaseService.updateTranCode(purchase, tranCode);
		
		System.out.println("/purchase/TranCode END =========================================================================");
		
		return "forward:/purchase/listPurchase";
	}
}