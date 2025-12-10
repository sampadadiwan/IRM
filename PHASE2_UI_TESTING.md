# Phase 2: UI Testing Guide

## Quick Start - Test from Browser

---

## **Step 1: Prepare Test Documents on Ubuntu**

```bash
mkdir -p /tmp/test_documents

cat > /tmp/test_documents/company_info.txt << 'EOF'
Company: TechCorp Inc.
Founded: 2020
Employees: 50
Product: Data Analytics Platform
Revenue 2023: $5 Million
Location: San Francisco
EOF

cat > /tmp/test_documents/financials.txt << 'EOF'
Q3 2024 Financials
Revenue: $1.5M
Expenses: $800K
Profit: $700K
Growth: 30% YoY
Customers: 120
EOF
```

---

## **Step 2: Push Controller Update**

**On Windows:**
```bash
cd C:\Users\talwa\Projects\IRM_Fresh

git add app/packs/ai/ai_portfolio_reports/controllers/ai_chat_messages_controller.rb
git commit -m "Update controller to pass document_folder_path to agent"
git push origin main
```

**On Ubuntu:**
```bash
cd ~/projects/IRM_Complete_Rails
git pull origin main
```

---

## **Step 3: Start Rails Server**

```bash
cd ~/projects/IRM_Complete_Rails

# Make sure MySQL Docker is running
docker ps | grep mysql

# Start Rails server
rails server
# Or: rails s -b 0.0.0.0 -p 3000
```

---

## **Step 4: Open Portfolio Report Chat in Browser**

1. Navigate to your portfolio report page
2. Open the AI chat interface
3. Ready to test!

---

## **Test Cases to Run**

### **Test 1: Basic Chat (Sanity Check)**

**Type in chat:**
```
Hello! What can you help me with?
```

**Expected:**
- AI responds with introduction
- Says it can help with portfolio analysis
- No errors

✅ If this works, basic chat is functional!

---

### **Test 2: Ask About Document Content**

**Type in chat:**
```
What was the Q3 revenue?
```

**Expected response:**
```
According to the financials.txt document, 
Q3 revenue was $1.5 million.
```

**Check:**
- ✅ AI mentions "$1.5M" or "1.5 million"
- ✅ AI cites "financials.txt" or "financials document"
- ✅ Response is accurate

---

### **Test 3: Ask About Another Document Field**

**Type in chat:**
```
How many employees does the company have?
```

**Expected response:**
```
According to company_info.txt, 
the company has 50 employees.
```

**Check:**
- ✅ AI says "50 employees"
- ✅ AI cites document name
- ✅ Accurate answer

---

### **Test 4: Ask About Missing Information**

**Type in chat:**
```
What is the CEO's salary?
```

**Expected response:**
```
I don't see information about the CEO's salary 
in the available documents.
```

**Check:**
- ✅ AI admits it doesn't know
- ✅ AI doesn't make up information
- ✅ References documents

---

### **Test 5: Memory Test**

**Type in chat:**
```
What have I asked you about so far?
```

**Expected response:**
```
You've asked me about Q3 revenue, 
the number of employees, and the CEO's salary.
```

**Check:**
- ✅ AI remembers previous questions
- ✅ Lists what you asked about
- ✅ Memory works with document context!

---

### **Test 6: Complex Question Using Multiple Documents**

**Type in chat:**
```
Based on the documents, what's the company's employee-to-customer ratio?
```

**Expected response:**
```
Based on the documents, TechCorp has 50 employees 
and 120 customers, giving an employee-to-customer 
ratio of approximately 1:2.4 (or about 0.42 employees per customer).
```

**Check:**
- ✅ AI combines info from multiple docs
- ✅ Does calculation correctly (50 employees, 120 customers)
- ✅ Provides meaningful answer

---

## **What the Controller Does**

```ruby
def create
  # ...
  
  # Hardcoded for testing - uses /tmp/test_documents
  folder_path = params[:document_folder_path] || "/tmp/test_documents"
  
  result = PortfolioChatAgent.call(
    support_agent_id: agent.id,
    target: @chat_session,
    user_message: params[:message],
    document_folder_path: folder_path  # ← Documents loaded!
  )
  
  # ...
end
```

**All chat requests now include documents from `/tmp/test_documents`!**

---

## **Check Browser Network Tab**

Open browser DevTools (F12) → Network tab

**When you send a message, check:**

1. **Request:**
```json
POST /ai_portfolio_reports/123/ai_chat_messages
{
  "message": "What was Q3 revenue?"
}
```

2. **Response:**
```json
{
  "success": true,
  "message_id": 456,
  "response": "According to financials.txt, Q3 revenue was $1.5M...",
  "session_id": 789
}
```

---

## **Check Rails Logs**

In terminal where Rails is running, watch for:

```
[PortfolioChatAgent] Loading documents from folder: /tmp/test_documents
[PortfolioChatAgent] Loaded 2 documents into context
[PortfolioChatAgent] Setting up assistant for chat session 123
[PortfolioChatAgent] Loaded 4 previous messages
[PortfolioChatAgent] Processing message: What was Q3 revenue?...
[PortfolioChatAgent] Generated response (245 chars)
[PortfolioChatAgent] Persisting 2 new messages
```

✅ If you see these logs, documents are being loaded!

---

## **Troubleshooting**

### **Issue: AI doesn't reference documents**

**Check logs for:**
```
[PortfolioChatAgent] No document folder path provided, skipping document context
```

**Or:**
```
[PortfolioChatAgent] Loaded 0 documents into context
```

**Solution:** Verify `/tmp/test_documents` exists with files

---

### **Issue: "Folder not found" error**

```bash
# On Ubuntu, verify:
ls -la /tmp/test_documents/
# Should show: company_info.txt, financials.txt
```

---

### **Issue: Response is generic (no document info)**

**Possible causes:**
1. Documents not loading
2. Document content extraction failed
3. LLM not using document context

**Debug:**
```ruby
# In Rails console
folder = "/tmp/test_documents"
Dir.glob(File.join(folder, "*"))
# Should show files

# Check file content
File.read("/tmp/test_documents/company_info.txt")
# Should show content
```

---

## **Success Criteria**

Phase 2 UI test is successful when:

- ✅ AI answers questions using document content
- ✅ AI cites document names
- ✅ AI acknowledges when info is missing
- ✅ Memory works (AI remembers previous questions)
- ✅ No errors in browser or Rails logs

---

## **Quick Test Checklist**

```
□ Test 1: Basic chat works
□ Test 2: AI found Q3 revenue ($1.5M)
□ Test 3: AI found employee count (50)
□ Test 4: AI said "don't know" for CEO salary
□ Test 5: AI remembered previous questions
□ Test 6: AI combined info from multiple docs
□ Logs show documents loading
□ No errors in browser console
□ No errors in Rails logs
```

---

## **Next: Make Document Path Dynamic**

After testing works, update controller to use actual document folder:

```ruby
# Instead of hardcoded:
folder_path = "/tmp/test_documents"

# Use from report (future):
folder_path = get_document_folder_path(@report)

# Or from params (if frontend sends it):
folder_path = params[:document_folder_path]

# Or from S3 (future):
folder_id = @report.document_folder_id
```

---

**Ready to test in browser!** 🚀

1. Push controller update
2. Pull on Ubuntu  
3. Create test documents
4. Start Rails server
5. Open chat in browser
6. Run the 6 test cases above

Let me know what happens! 🎯
