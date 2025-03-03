# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Admin user
admin = User.create!(email: 'admin@email.com', password: 'admin1', password_confirmation: 'admin1'),

# Brands
brooks = Brand.create!(name: 'Brooks', company_color: '#1375b8',
  logo: File.open('test/fixtures/files/brooks-logo.webp'),
  overview_en: 'Founded in 1914, Brooks is renowned for its innovative designs and technologies, aimed at enhancing comfort and performance for runners of all levels. The brand is highly regarded for its focus on biomechanics and personalized fit.',
  overview_es: 'Fundada en 1914, Brooks es famosa por sus innovadores diseños y tecnologías, cuyo objetivo es mejorar la comodidad y el rendimiento de los corredores de todos los niveles. La marca es muy valorada por su enfoque en la biomecánica y el ajuste personalizado.')
on_running = Brand.create!(name: 'On', company_color: '#000000',
  logo: File.open('test/fixtures/files/on-logo.webp'),
  overview_en: 'On, also known as On Running, is a Swiss company founded in 2010 that specializes in running shoes and sportswear. Renowned for its unique CloudTec cushioning technology, On shoes are designed to provide a soft landing and explosive takeoff. The brand quickly gained popularity for its innovative designs and performance-oriented footwear, attracting athletes and running enthusiasts worldwide.',
  overview_es: 'On, también conocida como On Running, es una empresa suiza fundada en 2010 que se especializa en zapatillas y ropa deportiva para correr. Conocida por su exclusiva tecnología de amortiguación CloudTec, las zapatillas On están diseñadas para proporcionar un aterrizaje suave y un despegue explosivo. La marca ganó popularidad rápidamente por sus diseños innovadores y su calzado orientado al rendimiento, atrayendo a atletas y entusiastas del running de todo el mundo.')
hoka = Brand.create!(name: 'HOKA', company_color: '#0077b8',
  logo: File.open('test/fixtures/files/hoka-logo.webp'),
  overview_en: 'Hoka One One, commonly referred to as Hoka, is an athletic shoe company founded in 2009 in France. Known for its maximalist shoes featuring oversized midsoles, Hoka footwear provides exceptional cushioning and support, making it popular among runners and outdoor enthusiasts. The brand has gained a reputation for its innovative design and commitment to enhancing athletic performance and comfort.',
  overview_es: 'Hoka One One, comúnmente conocida como Hoka, es una empresa de calzado deportivo fundada en 2009 en Francia. Conocida por sus zapatillas maximalistas con entresuelas de gran tamaño, el calzado Hoka proporciona una amortiguación y un soporte excepcionales, lo que la hace popular entre los corredores y los entusiastas del aire libre. La marca se ha ganado una reputación por su diseño innovador y su compromiso con la mejora del rendimiento y la comodidad atléticos.')
new_balance = Brand.create!(name: 'New Balance', company_color: '#cf0a2c',
  logo: File.open('test/fixtures/files/new-balance-logo.webp'),
  overview_en: 'New Balance, founded in 1906, is an American sports footwear and apparel brand known for its high-quality, performance-oriented products. The company emphasizes a blend of function and fashion, offering a wide range of sizes and widths to ensure a perfect fit. New Balance is celebrated for its commitment to comfort, innovative design, and manufacturing some of its products in the USA.',
  overview_es: 'New Balance, fundada en 1906, es una marca estadounidense de ropa y calzado deportivo conocida por sus productos de alta calidad y orientados al rendimiento. La empresa pone énfasis en una combinación de funcionalidad y moda, y ofrece una amplia gama de tallas y anchos para garantizar un ajuste perfecto. New Balance es reconocida por su compromiso con la comodidad, el diseño innovador y la fabricación de algunos de sus productos en los Estados Unidos.')

# Collections
brooks_ghost = Collection.create!(name: 'Ghost',
  overview_en: 'The Brooks Ghost line of shoes is renowned for its balanced cushioning and smooth ride, making it a favorite among neutral runners. These shoes offer a versatile fit, reliable comfort, and durability, catering to both everyday training and long-distance running. The Ghost series consistently receives high praise for its performance and comfort.',
  overview_es: 'La línea de zapatillas Brooks Ghost es famosa por su amortiguación equilibrada y su pisada suave, lo que la convierte en una de las favoritas entre los corredores neutrales. Estas zapatillas ofrecen un ajuste versátil, comodidad confiable y durabilidad, y se adaptan tanto al entrenamiento diario como a las carreras de larga distancia. La serie Ghost recibe constantemente grandes elogios por su rendimiento y comodidad.',
  brand: brooks)

brooks_ghost_max = Collection.create!(name: 'Ghost Max',
  overview_en: 'The Brooks Ghost Max is a cushioned running shoe designed to provide maximum comfort and support. It features enhanced cushioning and a soft, smooth ride, making it ideal for runners seeking extra protection and comfort during their runs. The Ghost Max combines the reliable performance of the Ghost line with added cushioning for a plush running experience.',
  overview_es: 'Brooks Ghost Max es una zapatilla para correr con amortiguación diseñada para brindar máxima comodidad y soporte. Cuenta con una amortiguación mejorada y una pisada suave y uniforme, lo que la hace ideal para corredores que buscan protección y comodidad adicionales durante sus carreras. Ghost Max combina el rendimiento confiable de la línea Ghost con una amortiguación adicional para una experiencia de carrera suave.',
  brand: brooks)

brooks_adrenaline_gts = Collection.create!(name: 'Adrenaline GTS',
  overview_en: 'The Brooks Adrenaline GTS is a stability running shoe designed to offer balanced support and cushioning. Known for its GuideRails support system, it helps runners maintain proper alignment, reducing the risk of injury. The Adrenaline GTS is popular for its reliable comfort, stability, and smooth ride, catering to overpronators and those seeking added support.',
  overview_es: 'Brooks Adrenaline GTS es una zapatilla para correr con estabilidad diseñada para ofrecer un soporte y una amortiguación equilibrados. Conocida por su sistema de soporte GuideRails, ayuda a los corredores a mantener una alineación adecuada, lo que reduce el riesgo de lesiones. Adrenaline GTS es popular por su comodidad confiable, estabilidad y pisada suave, ideal para pronadores y quienes buscan un soporte adicional.',
  brand: brooks)

hoka_bondi = Collection.create!(name: 'Bondi',
  overview_en: 'The Hoka Bondi line of shoes is renowned for its maximal cushioning and plush comfort, making it one of the most cushioned road running shoes available. Designed for long-distance running and high-impact activities, the Bondi series provides a smooth and stable ride, catering to runners seeking superior cushioning and support.',
  overview_es: 'La línea de zapatillas Bondi de Hoka es famosa por su máxima amortiguación y comodidad, lo que la convierte en una de las zapatillas para correr en ruta con mayor amortiguación disponible. Diseñada para carreras de larga distancia y actividades de alto impacto, la serie Bondi ofrece una pisada suave y estable, ideal para corredores que buscan una amortiguación y un soporte superiores.',
  brand: hoka)

hoka_clifton = Collection.create!(name: 'Clifton',
  overview_en: 'The Hoka Clifton line of shoes is celebrated for its lightweight design and balanced cushioning, offering a smooth and responsive ride. Ideal for daily training and long-distance running, the Clifton series combines comfort with performance, making it a favorite among runners seeking a versatile and reliable shoe.',
  overview_es: 'La línea de zapatillas Hoka Clifton es famosa por su diseño liviano y amortiguación equilibrada, que ofrece una pisada suave y reactiva. Ideal para el entrenamiento diario y las carreras de larga distancia, la serie Clifton combina comodidad con rendimiento, lo que la convierte en una de las favoritas entre los corredores que buscan una zapatilla versátil y confiable.',
  brand: hoka)

hoka_gaviota = Collection.create!(name: 'Gaviota',
  overview_en: 'The Hoka Gaviota is a stability running shoe designed to provide maximum cushioning and support for overpronators. It features a plush, cushioned ride combined with Hoka’s signature stability technologies to help maintain proper alignment and reduce the risk of injury, making it ideal for long-distance runs and daily training.',
  overview_es: 'La Gaviota de Hoka es una zapatilla de running con estabilidad diseñada para proporcionar la máxima amortiguación y sujeción a los pronadores. Ofrece una pisada suave y amortiguada combinada con las tecnologías de estabilidad exclusivas de Hoka para ayudar a mantener la alineación adecuada y reducir el riesgo de lesiones, lo que la hace ideal para carreras de larga distancia y entrenamiento diario.',
  brand: hoka)

hoka_speedgoat = Collection.create!(name: 'Speedgoat',
  overview_en: 'The Hoka Speedgoat is a trail running shoe designed for rugged terrain and challenging conditions. Known for its aggressive traction, durable construction, and ample cushioning, the Speedgoat provides excellent stability and comfort on rough and uneven surfaces, making it a popular choice for trail runners seeking performance and protection.',
  overview_es: 'La Speedgoat de Hoka es una zapatilla para trail running diseñada para terrenos accidentados y condiciones difíciles. Conocida por su tracción agresiva, su construcción duradera y su amplia amortiguación, la Speedgoat proporciona una excelente estabilidad y comodidad en superficies irregulares y ásperas, lo que la convierte en una opción popular para corredores de trail que buscan rendimiento y protección.',
  brand: hoka)

on_cloudmonster = Collection.create!(name: 'Cloudmonster',
  overview_en: 'The On Cloudmonster line features high-cushioning running shoes designed to deliver a plush, comfortable ride with a distinctive "monster" CloudTec sole. Engineered for maximum comfort and energy return, the Cloudmonster provides a smooth and cushioned experience, making it ideal for runners seeking both softness and performance.',
  overview_es: 'La línea On Cloudmonster cuenta con zapatillas para correr con gran amortiguación diseñadas para ofrecer una pisada suave y cómoda con una distintiva suela CloudTec "monstruosa". Diseñadas para lograr la máxima comodidad y retorno de energía, las Cloudmonster brindan una experiencia suave y amortiguada, lo que las hace ideales para corredores que buscan suavidad y rendimiento.',
  brand: on_running)

on_cloudvista = Collection.create!(name: 'Cloudvista',
  overview_en: 'The On Cloudvista is a trail running shoe designed for versatility and comfort on various terrains. It features a responsive CloudTec sole and enhanced traction, providing a cushioned and stable ride for trail runners navigating diverse and challenging surfaces.',
  overview_es: 'On Cloudvista es una zapatilla para trail running diseñada para ofrecer versatilidad y comodidad en distintos terrenos. Cuenta con una suela CloudTec reactiva y una tracción mejorada, lo que proporciona una pisada amortiguada y estable para corredores de trail que transitan por superficies diversas y desafiantes.',
  brand: on_running)

on_cloudsurfer_trail = Collection.create!(name: 'Cloudsurfer Trail',
  overview_en: 'The On Cloudsurfer Trail is a trail running shoe that combines cushioned comfort with responsive performance. Featuring On’s signature CloudTec technology and a durable outsole, it offers a smooth, adaptive ride and reliable traction on varied trail surfaces, making it ideal for runners seeking both comfort and performance on rugged terrain.',
  overview_es: 'Las On Cloudsurfer Trail son unas zapatillas para trail running que combinan comodidad y amortiguación con un rendimiento reactivo. Con la tecnología CloudTec característica de On y una suela exterior duradera, ofrecen una pisada suave y adaptable y una tracción fiable en diversas superficies de senderos, lo que las hace ideales para corredores que buscan comodidad y rendimiento en terrenos difíciles.',
  brand: on_running)

on_cloud_x = Collection.create!(name: 'Cloud X',
overview_en: 'The On Cloud X line of shoes is designed for versatile performance, suitable for both running and cross-training. Combining lightweight construction with responsive cushioning, the Cloud X features a flexible and durable design. It offers a comfortable, adaptive fit, making it ideal for athletes seeking a multipurpose shoe that excels in various activities.',
overview_es: 'La línea de zapatillas On Cloud X está diseñada para ofrecer un rendimiento versátil, adecuada tanto para correr como para el entrenamiento cruzado. Al combinar una construcción liviana con una amortiguación reactiva, las Cloud X presentan un diseño flexible y duradero. Ofrecen un ajuste cómodo y adaptable, lo que las hace ideales para los atletas que buscan una zapatilla multiusos que se destaque en diversas actividades.',
brand: on_running)

new_balance_fresh_foam_1080 = Collection.create!(name: 'Fresh Foam X 1080',
  overview_en: 'The New Balance Fresh Foam 1080 line is known for its plush cushioning and plush comfort, designed to provide a smooth and supportive ride for long-distance running. Featuring New Balance’s Fresh Foam midsole technology, the 1080 series delivers a responsive yet cushioned experience, making it ideal for runners seeking a blend of softness and performance.',
  overview_es: 'La línea Fresh Foam 1080 de New Balance es conocida por su amortiguación y comodidad, diseñadas para brindar una pisada suave y con soporte para carreras de larga distancia. Con la tecnología de entresuela Fresh Foam de New Balance, la serie 1080 brinda una experiencia reactiva y amortiguada, lo que la hace ideal para corredores que buscan una combinación de suavidad y rendimiento.',
  brand: new_balance)

# Models
brooks_ghost_16 = Model.create!(name: 'Ghost 16', weight: 269.3, heel_to_toe_drop: 12, collection: brooks_ghost,
  image: File.open('test/fixtures/files/brooks-ghost-16.webp'),
  tags: { activities: ['road_running', 'walking'], cushioning_level: 2, support: 'neutral', apma_accepted: false, discontinued: false })

brooks_ghost_max_1 = Model.create!(name: 'Ghost Max', weight: 283.5, heel_to_toe_drop: 6, collection: brooks_ghost_max,
  image: File.open('test/fixtures/files/brooks-ghost-max.webp'),
  tags: { activities: ['road_running', 'walking'], cushioning_level: 3, support: 'neutral', apma_accepted: true, discontinued: true })

brooks_adrenaline_gts_23 = Model.create!(name: 'Adrenaline GTS 23', weight: 286.3, heel_to_toe_drop: 12, collection: brooks_adrenaline_gts,
  image: File.open('test/fixtures/files/brooks-adrenaline-gts-23.webp'),
  tags: { activities: ['road_running', 'walking'], cushioning_level: 2, support: 'stability', apma_accepted: true, discontinued: false })

hoka_bondi_8 = Model.create!(name: 'Bondi 8', weight: 306.2, heel_to_toe_drop: 4, collection: hoka_bondi,
  image: File.open('test/fixtures/files/hoka-bondi-8.webp'),
  tags: { activities: ['road_running', 'walking'], cushioning_level: 3, support: 'neutral', apma_accepted: true, discontinued: false })

hoka_clifton_9 = Model.create!(name: 'Clifton 9', weight: 246.6, heel_to_toe_drop: 5, collection: hoka_clifton,
  image: File.open('test/fixtures/files/hoka-clifton-9.webp'),
  tags: { activities: ['road_running', 'walking'], cushioning_level: 2, support: 'neutral', apma_accepted: true, discontinued: false })

hoka_gaviota_5 = Model.create!(name: 'Gaviota 5', weight: 309.0, heel_to_toe_drop: 6, collection: hoka_gaviota,
  image: File.open('test/fixtures/files/hoka-gaviota-5.webp'),
  tags: { activities: ['road_running', 'walking'], cushioning_level: 3, support: 'stability', apma_accepted: true, discontinued: false })

hoka_speedgoat_5 = Model.create!(name: 'Speedgoat 5', weight: 292.0, heel_to_toe_drop: 4, collection: hoka_speedgoat,
  image: File.open('test/fixtures/files/hoka-speedgoat-5.webp'),
  tags: { activities: ['trail_running'], cushioning_level: 2, support: 'neutral', apma_accepted: true, discontinued: false })

on_cloudmonster_1 = Model.create!(name: 'Cloudmonster', weight: 230, heel_to_toe_drop: 6, collection: on_cloudmonster,
  image: File.open('test/fixtures/files/on-cloudmonster-1.webp'),
  tags: { activities: ['road_running', 'walking'], cushioning_level: 3, support: 'neutral', apma_accepted: false, discontinued: false })

on_cloudvista_1 = Model.create!(name: 'Cloudvista', weight: 280, heel_to_toe_drop: 9, collection: on_cloudvista,
  image: File.open('test/fixtures/files/on-cloudvista.webp'),
  tags: { activities: ['trail_running'], cushioning_level: 2, support: 'neutral', apma_accepted: false, discontinued: false })

on_cloudsurfer_trail_1 = Model.create!(name: 'Cloudsurfer Trail', weight: 275, heel_to_toe_drop: 7, collection: on_cloudsurfer_trail,
  image: File.open('test/fixtures/files/on-cloudsurfer-trail.webp'),
  tags: { activities: ['trail_running'], cushioning_level: 2, support: 'neutral', apma_accepted: false, discontinued: false })

on_cloud_x_4  = Model.create!(name: 'Cloud X 4', weight: 263, heel_to_toe_drop: 7, collection: on_cloud_x,
  image: File.open('test/fixtures/files/on-cloud-x-4.webp'),
  tags: { activities: ['training_and_gym'], cushioning_level: 1, support: 'neutral', apma_accepted: false, discontinued: false })

new_balance_fresh_foam_x_1080v13  = Model.create!(name: 'Fresh Foam X 1080v13', weight: 262, heel_to_toe_drop: 6, collection: new_balance_fresh_foam_1080,
  image: File.open('test/fixtures/files/new-balance-fresh-foam-x-1080v13.webp'),
  tags: { activities: ['road_running', 'walking'], cushioning_level: 3, support: 'neutral', apma_accepted: true, discontinued: false })

# Posts
my_doctor_told_me = Post.create!(
  title_en: "The doctor told me to get a new pair of shoes, but didn't specify the model, what should I do?",
  title_es: "El doctor me dijo que consiguiera nuevos zapatos, pero no especificó el modelo, ¿qué debería hacer?",
  overview_en: "Picture this scenario... you visit the doctor and he recommends you to get new shoes and mentions the Hokas. Excited, the next day you visit the shoe store and notice the impressive variety of Hokas, including models from Bondi and Clifton, to Ahari and Gaviota. Your doctor did not specify any particular model, so which one should you pick?",
  overview_es: "Imagina la siguiente situación... visitas al doctor y te recomienda un nuevo par de zapatos y menciona a los Hoka. Emocionado, al siguiente día visitas la tienda y te encuentras con la gran variedad de zapatos Hoka, desde el Bondi y Clifton, hasta el Arahi y Gaviota. Pero el doctor no mencionó ningún modelo en específico, entonces, ¿cuál deberías comprar?",
  content_en: '<div>This is the short and informative content of this blog.</div>',
  content_es: '<div>Este es el contenido corto e informativo de este blog.</div>',
  published: true,
  tags: ['healthcare']
  )
