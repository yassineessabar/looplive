-- Comprehensive demo data for all tables
-- This script populates all tables with realistic demo data

-- First, ensure we have our demo user
INSERT INTO users (id, email, password_hash, name, company, title, phone, store_type, timezone, language) 
VALUES (
  '550e8400-e29b-41d4-a716-446655440000',
  'demo@loop.com',
  '$2b$10$rOvHPxfzAXp0rtymDNF09uoyHrDh2FL4Db7FXGJgOyFFs4wkmHBvW', -- password123
  'Demo User',
  'Decathlon Sports',
  'Marketing Manager',
  '+33 6 12 34 56 78',
  'online',
  'Europe/Paris',
  'en'
) ON CONFLICT (email) DO UPDATE SET
  name = EXCLUDED.name,
  company = EXCLUDED.company,
  title = EXCLUDED.title,
  phone = EXCLUDED.phone,
  store_type = EXCLUDED.store_type,
  timezone = EXCLUDED.timezone,
  language = EXCLUDED.language;

-- Insert subscription data
INSERT INTO subscriptions (user_id, plan_name, plan_type, status, billing_cycle, amount, currency, current_period_start, current_period_end, usage_limits)
VALUES (
  '550e8400-e29b-41d4-a716-446655440000',
  'Professional',
  'professional',
  'active',
  'monthly',
  79.00,
  'EUR',
  NOW() - INTERVAL '15 days',
  NOW() + INTERVAL '15 days',
  '{"reviews_per_month": 500, "integrations": 5, "templates": 10, "workflows": 5}'
) ON CONFLICT (user_id) DO UPDATE SET
  plan_name = EXCLUDED.plan_name,
  plan_type = EXCLUDED.plan_type,
  status = EXCLUDED.status,
  billing_cycle = EXCLUDED.billing_cycle,
  amount = EXCLUDED.amount,
  currency = EXCLUDED.currency,
  current_period_start = EXCLUDED.current_period_start,
  current_period_end = EXCLUDED.current_period_end,
  usage_limits = EXCLUDED.usage_limits;

-- Insert invoice data
INSERT INTO invoices (user_id, subscription_id, invoice_number, amount, currency, status, invoice_date, due_date, paid_date) VALUES
('550e8400-e29b-41d4-a716-446655440000', (SELECT id FROM subscriptions WHERE user_id = '550e8400-e29b-41d4-a716-446655440000'), 'INV-2024-001', 79.00, 'EUR', 'paid', '2024-07-15', '2024-07-22', '2024-07-16'),
('550e8400-e29b-41d4-a716-446655440000', (SELECT id FROM subscriptions WHERE user_id = '550e8400-e29b-41d4-a716-446655440000'), 'INV-2024-002', 79.00, 'EUR', 'paid', '2024-06-15', '2024-06-22', '2024-06-16'),
('550e8400-e29b-41d4-a716-446655440000', (SELECT id FROM subscriptions WHERE user_id = '550e8400-e29b-41d4-a716-446655440000'), 'INV-2024-003', 79.00, 'EUR', 'paid', '2024-05-15', '2024-05-22', '2024-05-17'),
('550e8400-e29b-41d4-a716-446655440000', (SELECT id FROM subscriptions WHERE user_id = '550e8400-e29b-41d4-a716-446655440000'), 'INV-2024-004', 79.00, 'EUR', 'pending', NOW(), NOW() + INTERVAL '7 days', NULL)
ON CONFLICT (invoice_number) DO NOTHING;

-- Insert customization settings
INSERT INTO customization_settings (user_id, branding, messages, redirect_settings, theme_settings)
VALUES (
  '550e8400-e29b-41d4-a716-446655440000',
  '{
    "companyLogo": "/loop-logo.png",
    "smsName": "Decathlon",
    "emailName": "Decathlon Sports",
    "titleColor": "#e66465",
    "primaryColor": "#e66465",
    "secondaryColor": "#9198e5"
  }',
  '{
    "ratingPageContent": "Merci d''avoir choisi Decathlon ! Nous apprécions votre opinion et serions ravis que vous évaluiez votre expérience avec nous.",
    "redirectText": "Nous sommes ravis que vous ayez eu une bonne expérience ! Si vous pouviez prendre un moment pour laisser un avis sur Trustpilot, cela nous aiderait beaucoup.",
    "notificationText": "Nous sommes désolés que vous n''ayez pas apprécié votre expérience. Pourriez-vous nous donner plus de détails sur votre expérience avec nous ?",
    "skipRedirect": true
  }',
  '{
    "baseUrl": "moulai.io/redirect",
    "customId": "decathlon-reviews",
    "fullUrl": "https://moulai.io/redirect/decathlon-reviews"
  }',
  '{
    "darkMode": false,
    "compactMode": false,
    "showBranding": true
  }'
) ON CONFLICT (user_id) DO UPDATE SET
  branding = EXCLUDED.branding,
  messages = EXCLUDED.messages,
  redirect_settings = EXCLUDED.redirect_settings,
  theme_settings = EXCLUDED.theme_settings;

-- Insert notification settings
INSERT INTO notification_settings (user_id, email_notifications, sms_notifications, review_alerts, weekly_reports, marketing_emails, webhook_url)
VALUES (
  '550e8400-e29b-41d4-a716-446655440000',
  true,
  false,
  true,
  true,
  false,
  'https://api.decathlon.com/webhooks/reviews'
) ON CONFLICT (user_id) DO UPDATE SET
  email_notifications = EXCLUDED.email_notifications,
  sms_notifications = EXCLUDED.sms_notifications,
  review_alerts = EXCLUDED.review_alerts,
  weekly_reports = EXCLUDED.weekly_reports,
  marketing_emails = EXCLUDED.marketing_emails,
  webhook_url = EXCLUDED.webhook_url;

-- Insert review templates
INSERT INTO review_templates (user_id, name, type, subject, content, variables, is_active) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Post-Purchase Email', 'email', 'How was your Decathlon experience?', 
'Hi {{customer_name}},

Thank you for your recent purchase at Decathlon! We hope you''re enjoying your new sports equipment.

We''d love to hear about your experience. Could you take a moment to leave us a review?

{{review_link}}

Best regards,
The Decathlon Team', 
'{"customer_name": "Customer name", "review_link": "Review collection link", "company_name": "Company name"}', true),

('550e8400-e29b-41d4-a716-446655440000', 'Follow-up SMS', 'sms', NULL,
'Hi {{customer_name}}! Thanks for shopping at Decathlon. We''d love your feedback: {{review_link}}',
'{"customer_name": "Customer name", "review_link": "Review collection link"}', true),

('550e8400-e29b-41d4-a716-446655440000', 'VIP Customer Email', 'email', 'Your opinion matters to us',
'Dear {{customer_name}},

As one of our valued customers, your feedback is incredibly important to us.

We''d be grateful if you could share your recent experience with Decathlon:

{{review_link}}

Thank you for being a loyal customer!

Best regards,
{{company_name}} Team',
'{"customer_name": "Customer name", "review_link": "Review collection link", "company_name": "Company name"}', true)
ON CONFLICT DO NOTHING;

-- Insert automation workflows
INSERT INTO automation_workflows (user_id, name, trigger_type, trigger_conditions, actions, delay_hours, is_active, stats) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Post-Purchase Review Request', 'order_completed', 
'{"order_status": "completed", "order_value_min": 0}',
'{"send_email": true, "template_id": "post-purchase", "delay_hours": 72}',
72, true, '{"sent": 1234, "opened": 892, "clicked": 234}'),

('550e8400-e29b-41d4-a716-446655440000', 'Follow-up SMS', 'no_review_after_days', 
'{"days": 7, "initial_request_sent": true}',
'{"send_sms": true, "template_id": "follow-up-sms"}',
168, true, '{"sent": 456, "opened": 0, "clicked": 89}'),

('550e8400-e29b-41d4-a716-446655440000', 'VIP Customer Review', 'customer_segment', 
'{"segment": "vip", "purchase_count_min": 5}',
'{"send_email": true, "template_id": "vip-customer", "priority": "high"}',
24, false, '{"sent": 78, "opened": 65, "clicked": 23}')
ON CONFLICT DO NOTHING;

-- Insert integrations
INSERT INTO integrations (user_id, platform, platform_id, name, status, credentials, settings, last_sync, sync_status) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'google', 'ChIJd8BlQ2BZwokRAFUEcm_qrcA', 'Google My Business', 'connected', 
'{"api_key": "encrypted_key_123", "place_id": "ChIJd8BlQ2BZwokRAFUEcm_qrcA"}',
'{"auto_sync": true, "sync_frequency": "hourly", "import_responses": true}',
NOW() - INTERVAL '2 hours', 'completed'),

('550e8400-e29b-41d4-a716-446655440000', 'trustpilot', 'decathlon.com', 'Trustpilot', 'connected',
'{"api_key": "encrypted_trustpilot_key", "business_unit_id": "12345"}',
'{"auto_sync": true, "sync_frequency": "daily", "import_responses": true}',
NOW() - INTERVAL '1 hour', 'completed'),

('550e8400-e29b-41d4-a716-446655440000', 'facebook', '123456789', 'Facebook Reviews', 'disconnected',
'{}', '{"auto_sync": false}', NULL, 'idle'),

('550e8400-e29b-41d4-a716-446655440000', 'slack', 'T1234567890', 'Slack Notifications', 'connected',
'{"webhook_url": "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"}',
'{"channel": "#reviews", "notify_on": ["new_review", "negative_review"]}',
NOW() - INTERVAL '5 minutes', 'completed'),

('550e8400-e29b-41d4-a716-446655440000', 'shopify', 'decathlon-store', 'Shopify Store', 'connected',
'{"api_key": "encrypted_shopify_key", "shop_domain": "decathlon-store.myshopify.com"}',
'{"auto_sync": true, "sync_orders": true, "trigger_reviews": true}',
NOW() - INTERVAL '30 minutes', 'completed'),

('550e8400-e29b-41d4-a716-446655440000', 'zapier', NULL, 'Zapier Integration', 'disconnected',
'{}', '{"webhook_url": ""}', NULL, 'idle'),

('550e8400-e29b-41d4-a716-446655440000', 'webhook', NULL, 'Custom Webhook', 'connected',
'{"secret_key": "webhook_secret_123"}',
'{"url": "https://api.decathlon.com/webhooks/reviews", "events": ["review.created", "review.updated"]}',
NOW(), 'completed')
ON CONFLICT DO NOTHING;

-- Insert comprehensive review data
INSERT INTO reviews (user_id, customer_name, customer_email, customer_phone, rating, title, comment, platform, platform_review_id, status, response, response_date, helpful_count, verified, source, metadata) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Sarah Johnson', 'sarah.j@email.com', '+33 6 11 22 33 44', 5, 'Excellent service and quality!', 
'I recently purchased running shoes from Decathlon and I am extremely satisfied with both the product quality and customer service. The staff was knowledgeable and helped me find the perfect fit. The shoes are comfortable and durable. Highly recommend!', 
'Google', 'google_123456', 'published', 
'Thank you so much for your wonderful review, Sarah! We''re thrilled to hear that our team could help you find the perfect running shoes. Your satisfaction is our priority!', 
NOW() - INTERVAL '2 days', 15, true, 'google_sync', 
'{"order_id": "ORD-2024-001", "product_category": "footwear", "store_location": "Paris Centre"}'),

('550e8400-e29b-41d4-a716-446655440000', 'Mike Chen', 'mike.chen@email.com', '+33 6 22 33 44 55', 4, 'Good quality, fast delivery', 
'Ordered a camping tent online and it arrived quickly. The quality is good for the price point. Setup was straightforward with clear instructions. Only minor issue was the packaging could be more eco-friendly.', 
'Trustpilot', 'trustpilot_789012', 'published', 
'Hi Mike, thank you for your feedback! We''re glad you''re happy with your tent. We''re actually working on more sustainable packaging solutions - stay tuned!', 
NOW() - INTERVAL '1 day', 8, true, 'trustpilot_sync', 
'{"order_id": "ORD-2024-002", "product_category": "camping", "delivery_method": "home_delivery"}'),

('550e8400-e29b-41d4-a716-446655440000', 'Emma Wilson', 'emma.w@email.com', NULL, 2, 'Disappointed with customer service', 
'I had an issue with a defective bicycle I purchased. When I tried to return it, the process was complicated and the staff seemed unhelpful. It took multiple visits to resolve the issue. The product quality was fine, but the service experience was frustrating.', 
'Facebook', 'facebook_345678', 'pending', NULL, NULL, 3, false, 'facebook_sync', 
'{"order_id": "ORD-2024-003", "product_category": "cycling", "issue_type": "defective_product"}'),

('550e8400-e29b-41d4-a716-446655440000', 'David Brown', 'david.b@email.com', '+33 6 33 44 55 66', 5, 'Perfect for my fitness journey!', 
'Bought a complete home gym setup from Decathlon. Everything arrived on time, well-packaged, and exactly as described. The equipment is sturdy and perfect for my home workouts. Great value for money. Will definitely shop here again!', 
'Google', 'google_901234', 'published', 
'That''s fantastic, David! We''re so happy to be part of your fitness journey. Thank you for choosing Decathlon for your home gym setup!', 
NOW() - INTERVAL '3 hours', 22, true, 'google_sync', 
'{"order_id": "ORD-2024-004", "product_category": "fitness", "order_value": 850.00}'),

('550e8400-e29b-41d4-a716-446655440000', 'Lisa Garcia', 'lisa.g@email.com', '+33 6 44 55 66 77', 3, 'Average experience', 
'The swimming goggles I bought are okay. They do the job but nothing special. The price was reasonable. The store was busy and I had to wait a while to be served. Overall, it''s fine but not exceptional.', 
'Trustpilot', 'trustpilot_567890', 'published', NULL, NULL, 2, true, 'trustpilot_sync', 
'{"order_id": "ORD-2024-005", "product_category": "swimming", "store_location": "Lyon"}'),

('550e8400-e29b-41d4-a716-446655440000', 'Antoine Dubois', 'antoine.d@email.com', '+33 6 55 66 77 88', 5, 'Service client exceptionnel!', 
'J''ai eu un problème avec ma commande en ligne et l''équipe du service client a été formidable. Ils ont résolu mon problème rapidement et avec le sourire. Je recommande vivement Decathlon pour leur professionnalisme.', 
'Google', 'google_234567', 'published', 
'Merci beaucoup Antoine pour ce retour positif ! Notre équipe sera ravie de lire votre commentaire. Nous sommes là pour vous accompagner dans vos projets sportifs !', 
NOW() - INTERVAL '5 hours', 18, true, 'manual', 
'{"order_id": "ORD-2024-006", "language": "fr", "issue_resolved": true}'),

('550e8400-e29b-41d4-a716-446655440000', 'Jennifer Smith', 'jennifer.s@email.com', NULL, 4, 'Great selection of products', 
'Love the variety of sports equipment available. Found everything I needed for my tennis lessons. The staff was helpful in explaining the differences between rackets. Prices are competitive. Only wish there were more checkout counters during peak hours.', 
'Facebook', 'facebook_678901', 'published', NULL, NULL, 6, false, 'facebook_sync', 
'{"order_id": "ORD-2024-007", "product_category": "tennis", "staff_interaction": true}'),

('550e8400-e29b-41d4-a716-446655440000', 'Carlos Rodriguez', 'carlos.r@email.com', '+33 6 66 77 88 99', 1, 'Very poor experience', 
'Ordered a football online but received the wrong size. When I went to exchange it, they said they were out of stock and couldn''t offer a replacement. No alternative solutions were provided. Very disappointing customer service.', 
'Trustpilot', 'trustpilot_123789', 'flagged', NULL, NULL, 1, true, 'trustpilot_sync', 
'{"order_id": "ORD-2024-008", "product_category": "football", "issue_type": "wrong_size", "stock_issue": true}')
ON CONFLICT DO NOTHING;

-- Update user updated_at timestamp
UPDATE users SET updated_at = NOW() WHERE id = '550e8400-e29b-41d4-a716-446655440000';

-- Update all related tables updated_at timestamps
UPDATE subscriptions SET updated_at = NOW() WHERE user_id = '550e8400-e29b-41d4-a716-446655440000';
UPDATE customization_settings SET updated_at = NOW() WHERE user_id = '550e8400-e29b-41d4-a716-446655440000';
UPDATE notification_settings SET updated_at = NOW() WHERE user_id = '550e8400-e29b-41d4-a716-446655440000';
